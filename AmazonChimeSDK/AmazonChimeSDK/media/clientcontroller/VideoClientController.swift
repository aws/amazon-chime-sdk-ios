//
//  VideoClientController.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation
import AVFoundation

class VideoClientController: NSObject, VideoClientDelegate {
    enum VideoClientState: Int32 {
        case uninitialized = -1
        case initialized = 0
        case started = 1
        case stopped = 2
    }

    struct InstanceParams {
        let logger: Logger
        let isUsing16by9AspectRatio: Bool
    }

    private let frontCameraKeyword = "front"
    private let turnRequestHttpMethod = "POST"
    private let contentTypeHeader = "Content-Type"
    private let contentType = "application/json"
    private let tokenHeader = "X-Chime-Auth-Token"
    private let tokenKey = "_aws_wt_session"
    private let meetingIdKey = "meetingId"

    static let sharedInstance = VideoClientController()

    var logger: Logger?
    var isUsing16by9AspectRatio: Bool?
    var videoClient: VideoClient?
    var videoClientState: VideoClientState = .uninitialized
    var isSelfVideoSending: Bool = false
    var turnControlUrl: String?
    var signalingUrl: String?
    var meetingId: String?
    var joinToken: String?

    public class func setup(params: InstanceParams) {
        sharedInstance.logger = params.logger
        sharedInstance.isUsing16by9AspectRatio = params.isUsing16by9AspectRatio
    }

    override private init() {
        super.init()
    }

    public class func shared() -> VideoClientController {
        guard sharedInstance.logger != nil else {
            fatalError("You must call setup(logger:) before accessing VideoClientController.shared")
        }
        return sharedInstance
    }

    // MARK: - Lifecycle: start and initialize

    public func start(turnControlUrl: String,
                      signalingUrl: String,
                      meetingId: String,
                      joinToken: String,
                      sending: Bool) throws {
        if sending && AVCaptureDevice.authorizationStatus(for: .video) != .authorized {
            throw PermissionError.videoPermissionError
        }

        self.turnControlUrl = turnControlUrl
        self.signalingUrl = signalingUrl
        self.meetingId = meetingId
        self.joinToken = joinToken

        switch videoClientState {
        case .uninitialized:
            initialize()
            startInitializedVideoClient(sending: sending)
        case .started:
            logger?.info(msg: "VideoClientState is already STARTED")
        case .initialized, .stopped:
            startInitializedVideoClient(sending: sending)
        }
    }

    func initialize() {
        guard videoClientState == .uninitialized else {
            logger?.info(msg: "VideoClientState is not UNINITIALIZED, no need to initialize again")
            return
        }
        logger?.info(msg: "Initializing VideoClient")

        VideoClient.globalInitialize(nil)
        videoClient = VideoClient.init()
        videoClient?.delegate = self

        videoClientState = .initialized
    }

    func startInitializedVideoClient(sending: Bool) {
        guard videoClient != nil else {
            logger?.error(msg: "VideoClient is not initialized properly")
            return
        }
        logger?.info(msg: "Starting VideoClient with sending=\(sending)")
        enableSelfVideo(isEnabled: sending)

        let videoConfig: VideoConfiguration = VideoConfiguration.init()
        videoConfig.isUsing16by9AspectRatio = isUsing16by9AspectRatio ?? false

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

    // MARK: - Lifecycle: stop and destroy

    public func stopAndDestroy() {
        switch videoClientState {
        case .uninitialized:
            logger?.info(msg: "VideoClient is uninitialized so cannot be stopped and destroyed")
        case .started:
            stopVideoClient()
            destroyVideoClient()
        case .initialized, .stopped:
            destroyVideoClient()
        }
    }

    func stopVideoClient() {
        logger?.info(msg: "Stopping VideoClient")
        videoClient?.stop()
        isSelfVideoSending = false
        videoClientState = .stopped
    }

    func destroyVideoClient() {
        logger?.info(msg: "VideoClient is being destroyed")
        videoClient?.setCurrentDevice(nil)
        videoClient = nil
        videoClientState = .uninitialized
    }

    // MARK: - Video selection

    func enableSelfVideo(isEnabled: Bool) {
        guard videoClientState != .uninitialized else {
            logger?.info(msg: "VideoClient is not initialized so returning without doing anything")
            return
        }
        logger?.info(msg: "Enable Self Video with isEnabled=\(isEnabled)")

        isSelfVideoSending = isEnabled
        if isSelfVideoSending && VideoClient.currentDevice() == nil {
            setFrontCameraAsCurrentDevice()
        }

        videoClient?.setSending(isSelfVideoSending)
    }

    func setFrontCameraAsCurrentDevice() {
        guard videoClientState != .uninitialized else {
            logger?.error(msg: "Cannot set front camera as current device because videoClientState=\(videoClientState)")
            return
        }
        logger?.info(msg: "Setting front camera as current device")

        let currentDevice: VideoDevice? = VideoClient.currentDevice()
        if currentDevice == nil || !isDeviceFrontFacing(videoDevice: currentDevice!) {
            if let devices = (VideoClient.devices() as? [VideoDevice]) {
                if let frontDevice = devices.first(where: isDeviceFrontFacing) {
                    videoClient?.setCurrentDevice(frontDevice)
                }
            }
        }
    }

    func switchCamera() {
        guard videoClientState != .uninitialized else {
            logger?.error(msg: "Cannot switch camera because videoClientState=\(videoClientState)")
            return
        }
        logger?.info(msg: "Swiching between cameras")

        if let devices = (VideoClient.devices() as? [VideoDevice]) {
            if let nextDevice = devices.first(where: { $0.identifier != VideoClient.currentDevice()?.identifier }) {
                videoClient?.setCurrentDevice(nextDevice)
            }
        }
    }

    func isDeviceFrontFacing(videoDevice: VideoDevice) -> Bool {
        return videoDevice.name.lowercased().contains(frontCameraKeyword)
    }

    // MARK: - VideoClientDelegate

    // swiftlint:disable function_parameter_count
    public func videoClient(_ client: VideoClient!,
                            didReceiveFrame image: CGImage!,
                            displayId: Int32,
                            profileId: String!,
                            pause pauseType: video_client_pause_type_t,
                            videoId: UInt32) {
        logger?.info(msg: "videoClientDidReceiveFrame")
    }
    // swiftlint:enable function_parameter_count

    public func videoClientIsConnecting(_ client: VideoClient!) {
        logger?.info(msg: "videoClientIsConnecting")
    }

    public func videoClientDidConnect(_ client: VideoClient!, controlStatus: Int32) {
        logger?.info(msg: "videoClientDidConnect")
    }

    public func videoClientDidFail(_ client: VideoClient!, status: video_client_status_t, controlStatus: Int32) {
        logger?.info(msg: "videoClientDidFail")
    }

    public func videoClientDidStop(_ client: VideoClient!) {
        logger?.info(msg: "videoClientDidStop")
    }

    public func videoClient(_ client: VideoClient!, cameraSendIsAvailable available: Bool) {
        logger?.info(msg: "videoClientCameraSendIsAvailable")
    }

    public func videoClientRequestTurnCreds(_ videoClient: VideoClient!) {
        guard
            let turnControlUrl = turnControlUrl,
            let joinToken = self.joinToken,
            let serverUrl = URL(string: turnControlUrl)
        else {
            logger?.error(msg: "Failed to request TURN creds because required info is missing")
            return
        }
        logger?.info(msg: "Requesting TURN creds")

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
            logger?.error(msg: "Failed to set meetingId in TURN request payload, error: \(error.localizedDescription)")
            return
        }

        makeTurnRequest(request: request)
    }

    func makeTurnRequest(request: URLRequest) {
        URLSession.shared.dataTask(with: request) { data, resp, error in
            if let error = error {
                self.logger?.error(msg: "Failed to make TURN request, error: \(error.localizedDescription)")
                return
            }
            if let httpResponse = resp as? HTTPURLResponse {
                guard httpResponse.statusCode == 200 else {
                    self.logger?.error(msg: "Received status code \(httpResponse.statusCode) when making TURN request")
                    return
                }
            }
            guard let data = data else { return }
            self.logger?.info(msg: "TURN request success")

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
                self.logger?.error(msg: "Failed to decode TURN response, error: \(error.localizedDescription)")
                return
            }
        }.resume()
    }

    public func pauseResumeRemoteVideo(_ displayId: Int32, pause: Bool) {
        logger?.info(msg: "pauseResumeRemoteVideo")
    }
}
