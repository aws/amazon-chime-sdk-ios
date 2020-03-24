//
//  DefaultVideoClientController.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDKMedia
import AVFoundation
import Foundation
import UIKit

class DefaultVideoClientController: NSObject {

    var clientMetricsCollector: ClientMetricsCollector
    var joinToken: String?
    var logger: Logger
    var meetingId: String?
    var signalingUrl: String?
    var videoClient: VideoClient?
    var videoClientState: VideoClientState = .uninitialized
    var videoTileControllerObservers: NSMutableSet = NSMutableSet()
    var videoObservers: NSMutableSet = NSMutableSet()
    var turnControlUrl: String?

    private let contentTypeHeader = "Content-Type"
    private let contentType = "application/json"
    private let userAgentTypeHeader = "User-Agent"
    private let defaultVideoClient: VideoClient
    private let meetingIdKey = "meetingId"
    private let tokenHeader = "X-Chime-Auth-Token"
    private let tokenKey = "_aws_wt_session"
    private let turnRequestHttpMethod = "POST"

    init(videoClient: VideoClient, logger: Logger, clientMetricsCollector: ClientMetricsCollector) {
        self.defaultVideoClient = videoClient
        self.logger = logger
        self.clientMetricsCollector = clientMetricsCollector

        super.init()
    }

    private func getUserAgent() -> String {
        let model = UIDevice.current.model
        let systemVersion = UIDevice.current.systemVersion
        let scaleFactor = UIScreen.main.scale
        let defaultAgent = "(\(model); iOS \(systemVersion); Scale/\(String(format: "%.2f", scaleFactor)))"
        if let dict = Bundle.main.infoDictionary {
            if let identifier = dict[kCFBundleExecutableKey as String] ?? dict[kCFBundleIdentifierKey as String],
                let version = dict[kCFBundleVersionKey as String] {
                return "\(identifier)/\(version) \(defaultAgent)"
            }
        }
        return defaultAgent
    }

    private func getModelInfo() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        return machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    }

    private func forEachObserver<T>(observers: NSMutableSet, observerFunction: (_ observer: T) -> Void) {
        for observer in observers {
            if let observer = observer as? T {
                observerFunction(observer)
            }
        }
    }

    private func makeTurnRequest(request: URLRequest) {
        URLSession.shared.dataTask(with: request) { data, resp, error in
            if let error = error {
                self.logger.error(msg: "Failed to make TURN request, error: \(error.localizedDescription)")
                return
            }
            if let httpResponse = resp as? HTTPURLResponse {
                guard httpResponse.statusCode == 200 else {
                    self.logger.error(msg: "Received status code \(httpResponse.statusCode) when making TURN request")
                    return
                }
            }
            guard let data = data else { return }
            self.logger.info(msg: "TURN request success")

            let jsonDecoder = JSONDecoder()
            do {
                let turnCredentials: MeetingSessionTURNCredentials = try jsonDecoder.decode(
                    MeetingSessionTURNCredentials.self, from: data)

                let uriSize = turnCredentials.uris.count
                let uris = UnsafeMutablePointer<UnsafePointer<Int8>?>.allocate(capacity: uriSize)
                for index in 0..<uriSize {
                    let uri = turnCredentials.uris[index]
                    uris.advanced(by: index).pointee = (uri as NSString).utf8String
                }

                let turnResponse: turn_session_response_t = turn_session_response_t.init(
                    user_name: (turnCredentials.username as NSString).utf8String,
                    password: (turnCredentials.password as NSString).utf8String,
                    ttl: UInt64(turnCredentials.ttl),
                    signaling_url: (self.signalingUrl! as NSString).utf8String,
                    turn_data_uris: uris,
                    size: Int32(uriSize))

                self.videoClient?.updateTurnCreds(turnResponse, turn: VIDEO_CLIENT_TURN_FEATURE_ON)
            } catch {
                self.logger.error(msg: "Failed to decode TURN response, error: \(error.localizedDescription)")
                return
            }
        }.resume()
    }

    // MARK: VideoClientController

    private func checkVideoPermission() throws {
        if AVCaptureDevice.authorizationStatus(for: .video) != .authorized {
            throw PermissionError.videoPermissionError
        }
    }

    func isDeviceFrontFacing(videoDevice: VideoDevice) -> Bool {
        return MediaDevice.fromVideoDevice(device: videoDevice).type == .videoFrontCamera
    }

    private func stopVideoClient() {
        logger.info(msg: "Stopping VideoClient")
        videoClient?.stop()
        videoClientState = .stopped
    }

    private func destroyVideoClient() {
        logger.info(msg: "VideoClient is being destroyed")
        videoClient = nil
        videoClientState = .uninitialized
    }

    func setFrontCameraAsCurrentDevice() {
        guard videoClientState != .uninitialized else {
            logger.error(msg: "Cannot set front camera as current device because videoClientState=\(videoClientState)")
            return
        }

        logger.info(msg: "Setting front camera as current device")

        let currentDevice: VideoDevice? = VideoClient.currentDevice()
        if currentDevice == nil || !isDeviceFrontFacing(videoDevice: currentDevice!) {
            if let devices = (VideoClient.devices() as? [VideoDevice]) {
                if let frontDevice = devices.first(where: isDeviceFrontFacing) {
                    videoClient?.setCurrentDevice(frontDevice)
                }
            }
        }
    }

    func initialize() {
        guard videoClientState == .uninitialized else {
            logger.info(msg: "VideoClientState is not UNINITIALIZED, no need to initialize again")
            return
        }
        logger.info(msg: "Initializing VideoClient")
        videoClient = defaultVideoClient
        videoClient?.delegate = self
        videoClientState = .initialized
    }

    func startInitializedVideoClient() {
        guard videoClient != nil else {
            logger.error(msg: "VideoClient is not initialized properly")
            return
        }
        logger.info(msg: "Starting VideoClient")

        let videoConfig: VideoConfiguration = VideoConfiguration()
        videoConfig.isUsing16by9AspectRatio = true
        videoConfig.isUsingPixelBufferRenderer = true

        // Default to idle mode, no video but signaling connection is
        // established for messaging
        videoClient?.setReceiving(false)
        var appInfo = app_detailed_info_t.init()

        appInfo.platform_version = UnsafePointer<Int8>((UIDevice.current.systemVersion as NSString).utf8String)
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] {
            appInfo.app_version_name = UnsafePointer<Int8>(("iOS \(appVersion)" as NSString).utf8String)
            appInfo.app_version_code = UnsafePointer<Int8>(("\(appVersion)" as NSString).utf8String)
        }
        appInfo.device_model = UnsafePointer<Int8>((getModelInfo() as NSString).utf8String)
        appInfo.platform_name = UnsafePointer<Int8>(("iOS" as NSString).utf8String)
        appInfo.device_make = UnsafePointer<Int8>(("apple" as NSString).utf8String)

        videoClient!.start(meetingId,
                           token: joinToken,
                           sending: false,
                           config: videoConfig,
                           appInfo: appInfo)
        videoClientState = .started
    }
}

// MARK: - VideoClientDelegate

extension DefaultVideoClientController: VideoClientDelegate {
    func didReceive(_ buffer: CVPixelBuffer!, profileId: String!, pauseState: PauseState, videoId: UInt32) {
        // Translate the Obj-C enum to the public Swift enum
        var translatedPauseState: VideoPauseState
        switch pauseState {
        case .Unpaused:
            translatedPauseState = .unpaused
        case .PausedByUserRequest:
            translatedPauseState = .pausedByUserRequest
        case .PausedForPoorConnection:
            translatedPauseState = .pausedForPoorConnection
        default:
            translatedPauseState = .unpaused
        }

        forEachObserver(observers: videoTileControllerObservers) { (observer: VideoTileController) in
            observer.onReceiveFrame(frame: buffer,
                                    attendeeId: profileId,
                                    pauseState: translatedPauseState,
                                    videoId: Int(videoId))
        }
    }

    // swiftlint:enable function_parameter_count
    public func videoClientIsConnecting(_ client: VideoClient!) {
        logger.info(msg: "videoClientIsConnecting")
        forEachObserver(observers: videoObservers) { (observer: AudioVideoObserver) in
            observer.videoSessionDidStartConnecting()
        }
    }

    public func videoClientDidConnect(_ client: VideoClient!, controlStatus: Int32) {
        logger.info(msg: "videoClientDidConnect, \(controlStatus)")
        forEachObserver(observers: videoObservers) { (observer: AudioVideoObserver) in
            switch Int(controlStatus) {
            case Constants.videoClientStatusCallAtCapacityViewOnly:
                observer.videoSessionDidStartWithStatus(
                    sessionStatus: MeetingSessionStatus(statusCode: MeetingSessionStatusCode.videoAtCapacityViewOnly)
                )
            default:
                observer.videoSessionDidStartWithStatus(sessionStatus:
                    MeetingSessionStatus(statusCode: MeetingSessionStatusCode.ok))
            }
        }
    }

    public func videoClientDidFail(_ client: VideoClient!, status: video_client_status_t, controlStatus: Int32) {
        logger.info(msg: "videoClientDidFail")
        forEachObserver(observers: videoObservers) { (observer: AudioVideoObserver) in
            observer.videoSessionDidStopWithStatus(sessionStatus:
                MeetingSessionStatus(statusCode: .videoServiceUnavailable))
        }
    }

    public func videoClientDidStop(_ client: VideoClient!) {
        logger.info(msg: "videoClientDidStop")
        forEachObserver(observers: videoObservers) { (observer: AudioVideoObserver) in
            observer.videoSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus(statusCode: .ok))
        }
    }

    public func videoClient(_ client: VideoClient!, cameraSendIsAvailable available: Bool) {
        logger.info(msg: "videoClientCameraSendIsAvailable")
    }

    public func videoClientRequestTurnCreds(_ videoClient: VideoClient!) {
        guard
            let turnControlUrl = turnControlUrl,
            let joinToken = self.joinToken,
            let serverUrl = URL(string: turnControlUrl)
        else {
            logger.error(msg: "Failed to request TURN creds because required info is missing")
            return
        }
        logger.info(msg: "Requesting TURN creds")

        // Prepare TURN request
        var request = URLRequest(url: serverUrl)
        request.httpMethod = turnRequestHttpMethod
        request.addValue("\(tokenKey)=\(joinToken)", forHTTPHeaderField: tokenHeader)
        request.addValue(contentType, forHTTPHeaderField: contentTypeHeader)
        request.addValue(getUserAgent(), forHTTPHeaderField: userAgentTypeHeader)

        // Write meetingId into HTTP request body
        let meetingIdDict = [meetingIdKey: meetingId]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: meetingIdDict)
        } catch {
            logger.error(msg: "Failed to set meetingId in TURN request payload, error: \(error.localizedDescription)")
            return
        }

        makeTurnRequest(request: request)
    }

    public func videoClientMetricsReceived(_ metrics: [AnyHashable: Any]!) {
        clientMetricsCollector.processVideoClientMetrics(metrics: metrics)
    }
}

extension DefaultVideoClientController: VideoClientController {
    // MARK: - Lifecycle: start and initialize

    public func start(turnControlUrl: String,
                      signalingUrl: String,
                      meetingId: String,
                      joinToken: String) {
        self.turnControlUrl = turnControlUrl
        self.signalingUrl = signalingUrl
        self.meetingId = meetingId
        self.joinToken = joinToken

        switch videoClientState {
        case .uninitialized:
            initialize()
            startInitializedVideoClient()
        case .started:
            logger.info(msg: "VideoClientState is already STARTED")
        case .initialized, .stopped:
            startInitializedVideoClient()
        }
    }

    // MARK: - Lifecycle: stop and destroy

    public func stopAndDestroy() {
        switch videoClientState {
        case .uninitialized:
            logger.info(msg: "VideoClient is uninitialized so cannot be stopped and destroyed")
        case .started:
            stopVideoClient()
            destroyVideoClient()
        case .initialized, .stopped:
            destroyVideoClient()
        }
    }

    // MARK: - Video selection

    public func startLocalVideo() throws {
        guard videoClientState != .uninitialized else {
            logger.fault(msg: "VideoClient is not initialized so returning without doing anything")
            return
        }
        try checkVideoPermission()

        logger.info(msg: "Starting local video")
        if VideoClient.currentDevice() == nil {
            setFrontCameraAsCurrentDevice()
        }
        videoClient?.setSending(true)
    }

    public func stopLocalVideo() {
        guard videoClientState != .uninitialized else {
            logger.fault(msg: "VideoClient is not initialized so returning without doing anything")
            return
        }
        logger.info(msg: "Stopping local video")
        videoClient?.setSending(false)
    }

    public func startRemoteVideo() {
        guard videoClientState != .uninitialized else {
            logger.fault(msg: "VideoClient is not initialized so returning without doing anything")
            return
        }
        logger.info(msg: "Starting remote video")
        videoClient?.setReceiving(true)
    }

    public func stopRemoteVideo() {
        guard videoClientState != .uninitialized else {
            logger.fault(msg: "VideoClient is not initialized so returning without doing anything")
            return
        }
        logger.info(msg: "Stopping remote video")
        videoClient?.setReceiving(false)
    }

    public func switchCamera() {
        guard videoClientState != .uninitialized else {
            logger.error(msg: "Cannot switch camera because videoClientState=\(videoClientState)")
            return
        }

        logger.info(msg: "Swiching between cameras")

        if let devices = (VideoClient.devices() as? [VideoDevice]) {
            if let nextDevice = devices.first(where: { $0.identifier != VideoClient.currentDevice()?.identifier }) {
                videoClient?.setCurrentDevice(nextDevice)
            }
        }
    }

    public func getCurrentDevice() -> VideoDevice? {
        return VideoClient.currentDevice()
    }

    public func subscribeToVideoClientStateChange(observer: AudioVideoObserver) {
        videoObservers.add(observer)
    }

    public func unsubscribeToVideoClientStateChange(observer: AudioVideoObserver) {
        videoObservers.remove(observer)
    }

    public func subscribeToVideoTileControllerObservers(observer: VideoTileController) {
        videoTileControllerObservers.add(observer)
    }

    public func unsubscribeToVideoTileControllerObservers(observer: VideoTileController) {
        videoTileControllerObservers.remove(observer)
    }

    public func pauseResumeRemoteVideo(_ videoId: UInt32, pause: Bool) {
        logger.info(msg: "pauseResumeRemoteVideo")
        videoClient?.setRemotePause(videoId, pause: pause)
    }
}
