//
//  DefaultVideoClientController.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import AVFoundation
import Foundation

class DefaultVideoClientController: NSObject {
    var logger: Logger
    var isUsing16by9AspectRatio: Bool
    var videoClient: VideoClient?
    var clientMetricsCollector: ClientMetricsCollector
    var videoClientState: VideoClientState = .uninitialized
    var videoTileControllerObservers: NSMutableSet = NSMutableSet()
    var videoObservers: NSMutableSet = NSMutableSet()
    var isSelfVideoSending: Bool = false
    var turnControlUrl: String?
    var signalingUrl: String?
    var meetingId: String?
    var joinToken: String?

    private let turnRequestHttpMethod = "POST"
    private let contentTypeHeader = "Content-Type"
    private let contentType = "application/json"
    private let tokenHeader = "X-Chime-Auth-Token"
    private let tokenKey = "_aws_wt_session"
    private let meetingIdKey = "meetingId"

    init(logger: Logger, clientMetricsCollector: ClientMetricsCollector, isUsing16by9AspectRatio: Bool) {
        self.logger = logger
        self.clientMetricsCollector = clientMetricsCollector
        self.isUsing16by9AspectRatio = isUsing16by9AspectRatio

        super.init()
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

    private func checkVideoPermission(sending: Bool) throws {
        if sending, AVCaptureDevice.authorizationStatus(for: .video) != .authorized {
            throw PermissionError.videoPermissionError
        }
    }

    func isDeviceFrontFacing(videoDevice: VideoDevice) -> Bool {
        return MediaDevice.fromVideoDevice(device: videoDevice).type == .videoFrontCamera
    }

    private func stopVideoClient() {
        logger.info(msg: "Stopping VideoClient")
        videoClient?.stop()
        isSelfVideoSending = false
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

        // TODO: will this be possible to pass from init?
        VideoClient.globalInitialize(nil)
        videoClient = VideoClient()
        videoClient?.delegate = self

        videoClientState = .initialized
    }

    func startInitializedVideoClient(sending: Bool) throws {
        guard videoClient != nil else {
            logger.error(msg: "VideoClient is not initialized properly")
            return
        }
        logger.info(msg: "Starting VideoClient with sending=\(sending)")
        try enableSelfVideo(isEnabled: sending)

        let videoConfig: VideoConfiguration = VideoConfiguration()
        videoConfig.isUsing16by9AspectRatio = isUsing16by9AspectRatio

        videoClient!.start(nil,
                           proxyCallback: nil,
                           stunServerUrl: nil,
                           callId: meetingId,
                           token: joinToken,
                           sending: sending,
                           config: videoConfig,
                           appInfo: app_detailed_info_t.init())
        videoClientState = .started
    }
}

// MARK: - VideoClientDelegate

extension DefaultVideoClientController: VideoClientDelegate {
    // swiftlint:disable function_parameter_count
    public func videoClient(_ client: VideoClient!,
                            didReceiveFrame image: CGImage!,
                            displayId: Int32,
                            profileId: String!,
                            pause pauseType: video_client_pause_type_t,
                            videoId: UInt32) {
        forEachObserver(observers: videoTileControllerObservers) { (observer: VideoTileController) in
            observer.onReceiveFrame(frame: image,
                                    profileId: profileId,
                                    displayId: Int(displayId),
                                    pauseType: Int(pauseType.rawValue),
                                    videoId: Int(videoId))
        }
    }

    // swiftlint:enable function_parameter_count
    public func videoClientIsConnecting(_ client: VideoClient!) {
        logger.info(msg: "videoClientIsConnecting")
        forEachObserver(observers: videoObservers) { (observer: AudioVideoObserver) in
            observer.onVideoClientConnecting()
        }
    }

    public func videoClientDidConnect(_ client: VideoClient!, controlStatus: Int32) {
        logger.info(msg: "videoClientDidConnect")
        forEachObserver(observers: videoObservers) { (observer: AudioVideoObserver) in
            observer.onVideoClientStart()
        }
    }

    public func videoClientDidFail(_ client: VideoClient!, status: video_client_status_t, controlStatus: Int32) {
        logger.info(msg: "videoClientDidFail")
        forEachObserver(observers: videoObservers) { (observer: AudioVideoObserver) in
            observer.onVideoClientStop(sessionStatus: MeetingSessionStatus(statusCode: .videoServiceUnavailable))
        }
    }

    public func videoClientDidStop(_ client: VideoClient!) {
        logger.info(msg: "videoClientDidStop")
        forEachObserver(observers: videoObservers) { (observer: AudioVideoObserver) in
            observer.onVideoClientStop(sessionStatus: MeetingSessionStatus(statusCode: .ok))
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
                      joinToken: String,
                      sending: Bool) throws {
        try checkVideoPermission(sending: sending)

        self.turnControlUrl = turnControlUrl
        self.signalingUrl = signalingUrl
        self.meetingId = meetingId
        self.joinToken = joinToken

        switch videoClientState {
        case .uninitialized:
            initialize()
            try startInitializedVideoClient(sending: sending)
        case .started:
            logger.info(msg: "VideoClientState is already STARTED")
        case .initialized, .stopped:
            try startInitializedVideoClient(sending: sending)
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

    public func enableSelfVideo(isEnabled: Bool) throws {
        guard videoClientState != .uninitialized else {
            logger.info(msg: "VideoClient is not initialized so returning without doing anything")
            return
        }
        logger.info(msg: "Enable Self Video with isEnabled=\(isEnabled)")

        isSelfVideoSending = isEnabled
        try checkVideoPermission(sending: isSelfVideoSending)

        if isSelfVideoSending, VideoClient.currentDevice() == nil {
            setFrontCameraAsCurrentDevice()
        }

        videoClient?.setSending(isSelfVideoSending)
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
        self.videoClient?.setRemotePause(videoId, pause: pause)
    }
}
