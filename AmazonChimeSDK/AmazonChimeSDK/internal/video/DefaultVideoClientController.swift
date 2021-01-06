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
    var logger: Logger
    var videoClient: VideoClient?
    var videoSourceAdapter = VideoSourceAdapter()
    var videoClientState: VideoClientState = .uninitialized
    let videoTileControllerObservers = ConcurrentMutableSet()
    let videoObservers = ConcurrentMutableSet()
    var dataMessageObservers = [String: ConcurrentMutableSet]()

    private let configuration: MeetingSessionConfiguration
    private let defaultVideoClient: VideoClient

    // This internal camera capture source is used for `startLocalVideo()` API without parameter.
    private let internalCaptureSource: DefaultCameraCaptureSource
    private var isInternalCaptureSourceRunning = true

    init(videoClient: VideoClient,
         clientMetricsCollector: ClientMetricsCollector,
         configuration: MeetingSessionConfiguration,
         logger: Logger) {
        self.defaultVideoClient = videoClient
        self.clientMetricsCollector = clientMetricsCollector
        self.configuration = configuration
        self.logger = logger
        self.internalCaptureSource = DefaultCameraCaptureSource(logger: logger)
        super.init()
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

        let currentDevice = VideoClient.currentDevice()
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
        guard let videoClient = videoClient else {
            logger.error(msg: "VideoClient is not initialized properly")
            return
        }
        logger.info(msg: "Starting VideoClient")

        let videoConfig: VideoConfiguration = VideoConfiguration()
        videoConfig.isUsing16by9AspectRatio = true
        videoConfig.isUsingPixelBufferRenderer = true
        videoConfig.isUsingOptimizedTwoSimulcastStreamTable = true
        videoConfig.isExcludeSelfContentInIndex = true

        // Default to idle mode, no video but signaling connection is
        // established for messaging
        videoClient.setReceiving(false)

        videoClient.start(configuration.meetingId,
                          token: configuration.credentials.joinToken,
                          sending: false,
                          config: videoConfig,
                          appInfo: DeviceUtils.getDetailedInfo())
        videoClientState = .started
    }
}

// MARK: - VideoClientDelegate

extension DefaultVideoClientController: VideoClientDelegate {
    func didReceive(_ buffer: CVPixelBuffer?,
                    profileId: String?,
                    pauseState: PauseState,
                    videoId: UInt32,
                    timestampNs: Int64,
                    rotation: VideoRotationInternal) {
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

        var frame: VideoFrame?
        if let buffer = buffer {
            let pixelBuffer = VideoFramePixelBuffer(pixelBuffer: buffer)
            frame = VideoFrame(timestampNs: timestampNs,
                               rotation: VideoRotation(internalValue: rotation),
                               buffer: pixelBuffer)
        }
        ObserverUtils.forEach(observers: videoTileControllerObservers) { (observer: VideoTileController) in
            observer.onReceiveFrame(frame: frame,
                                    videoId: Int(videoId),
                                    attendeeId: profileId,
                                    pauseState: translatedPauseState)
        }
    }

    // swiftlint:enable function_parameter_count
    public func videoClientIsConnecting(_ client: VideoClient?) {
        logger.info(msg: "videoClientIsConnecting")
        ObserverUtils.forEach(observers: videoObservers) { (observer: AudioVideoObserver) in
            observer.videoSessionDidStartConnecting()
        }
    }

    public func videoClientDidConnect(_ client: VideoClient?, controlStatus: Int32) {
        logger.info(msg: "videoClientDidConnect, \(controlStatus)")
        ObserverUtils.forEach(observers: videoObservers) { (observer: AudioVideoObserver) in
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

    public func videoClientDidFail(_ client: VideoClient?, status: video_client_status_t, controlStatus: Int32) {
        logger.info(msg: "videoClientDidFail")
        ObserverUtils.forEach(observers: videoObservers) { (observer: AudioVideoObserver) in
            observer.videoSessionDidStopWithStatus(sessionStatus:
                MeetingSessionStatus(statusCode: .videoServiceUnavailable))
        }
    }

    public func videoClientDidStop(_ client: VideoClient?) {
        logger.info(msg: "videoClientDidStop")
        ObserverUtils.forEach(observers: videoObservers) { (observer: AudioVideoObserver) in
            observer.videoSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus(statusCode: .ok))
        }
    }

    public func videoClient(_ client: VideoClient?, cameraSendIsAvailable available: Bool) {
        logger.info(msg: "videoClientCameraSendIsAvailable")
    }

    public func videoClientRequestTurnCreds(_ videoClient: VideoClient?) {
        let turnControlUrl = configuration.urls.turnControlUrl
        let joinToken = configuration.credentials.joinToken
        let meetingId = configuration.meetingId
        let signalingUrl = configuration.urls.signalingUrl

        logger.info(msg: "Requesting TURN creds")

        TURNRequestService.postTURNRequest(meetingId: meetingId,
                                           turnControlUrl: turnControlUrl,
                                           joinToken: joinToken,
                                           logger: logger) { [weak self] turnCredentials in
            if let strongSelf = self, let turnCredentials = turnCredentials {
                let turnResponse = turnCredentials.toTURNSessionResponse(urlRewriter: strongSelf.configuration.urlRewriter,
                                                                         signalingUrl: signalingUrl)
                strongSelf.videoClient?.updateTurnCreds(turnResponse, turn: VIDEO_CLIENT_TURN_FEATURE_ON)
            }
        }
    }

    public func videoClientMetricsReceived(_ metrics: [AnyHashable: Any]?) {
        guard let metrics = metrics else { return }
        clientMetricsCollector.processVideoClientMetrics(metrics: metrics)
    }

    public func videoClientDataMessageReceived(_ messages: [DataMessageInternal]?) {
        guard let messages = messages else { return }
        for message in messages {
            let dataMessage = DataMessage(message: message)
            if let observers = dataMessageObservers[dataMessage.topic] {
                ObserverUtils.forEach(observers: observers) { (observer: DataMessageObserver) in
                    observer.dataMessageDidReceived(dataMessage: dataMessage)
                }
            }
        }
    }
}

extension DefaultVideoClientController: VideoClientController {
    // MARK: - Lifecycle: start and initialize

    public func start() {
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
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else { return }
            switch strongSelf.videoClientState {
            case .uninitialized:
                strongSelf.logger.info(msg: "VideoClient is uninitialized so cannot be stopped and destroyed")
            case .started:
                strongSelf.stopVideoClient()
                strongSelf.destroyVideoClient()
            case .initialized, .stopped:
                strongSelf.destroyVideoClient()
            }
        }
    }

    // MARK: - Video selection

    public func startLocalVideo() throws {
        try checkVideoPermission()
        setVideoSource(source: internalCaptureSource)

        logger.info(msg: "Starting local video with internal source")
        internalCaptureSource.start()
        isInternalCaptureSourceRunning = true
    }

    public func startLocalVideo(source: VideoSource) {
        if isInternalCaptureSourceRunning {
            internalCaptureSource.stop()
            isInternalCaptureSourceRunning = false
        }
        setVideoSource(source: source)

        logger.info(msg: "Starting local video with custom source")
    }

    private func setVideoSource(source: VideoSource) {
        guard videoClientState != .uninitialized else {
            logger.fault(msg: "VideoClient is not initialized so returning without doing anything")
            return
        }

        videoSourceAdapter.source = source
        videoClient?.setExternalVideoSource(videoSourceAdapter)
        videoClient?.setSending(true)
    }

    public func stopLocalVideo() {
        guard videoClientState != .uninitialized else {
            logger.fault(msg: "VideoClient is not initialized so returning without doing anything")
            return
        }
        logger.info(msg: "Stopping local video")
        videoClient?.setSending(false)
        if isInternalCaptureSourceRunning {
            internalCaptureSource.stop()
            isInternalCaptureSourceRunning = false
        }
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
        if isInternalCaptureSourceRunning {
            logger.info(msg: "Switching camera on internal source")
            internalCaptureSource.switchCamera()
        }
    }

    public func getCurrentDevice() -> MediaDevice? {
        if isInternalCaptureSourceRunning {
            return internalCaptureSource.device
        }
        return nil
    }

    public func getConfiguration() -> MeetingSessionConfiguration {
        return configuration
    }

    public func subscribeToVideoClientStateChange(observer: AudioVideoObserver) {
        videoObservers.add(observer)
    }

    public func unsubscribeFromVideoClientStateChange(observer: AudioVideoObserver) {
        videoObservers.remove(observer)
    }

    public func subscribeToVideoTileControllerObservers(observer: VideoTileController) {
        videoTileControllerObservers.add(observer)
    }

    public func unsubscribeFromVideoTileControllerObservers(observer: VideoTileController) {
        videoTileControllerObservers.remove(observer)
    }

    public func pauseResumeRemoteVideo(_ videoId: UInt32, pause: Bool) {
        logger.info(msg: "pauseResumeRemoteVideo")
        videoClient?.setRemotePause(videoId, pause: pause)
    }

    public func subscribeToReceiveDataMessage(topic: String, observer: DataMessageObserver) {
        if dataMessageObservers[topic] == nil {
            dataMessageObservers[topic] = ConcurrentMutableSet()
        }
        dataMessageObservers[topic]?.add(observer)
    }

    public func unsubscribeFromReceiveDataMessageFromTopic(topic: String) {
        dataMessageObservers.removeValue(forKey: topic)
    }

    public func sendDataMessage(topic: String, data: Any, lifetimeMs: Int32 = 0) throws {
        guard videoClientState == .started else {
            logger.error(msg: "Cannot send data message because videoClientState=\(videoClientState)")
            return
        }

        if lifetimeMs < 0 {
            throw SendDataMessageError.negativeLifetimeParameter
        }

        if topic.range(of: Constants.dataMessageTopicRegex, options: .regularExpression) == nil {
            throw SendDataMessageError.invalidTopic
        }

        var dataContainer: Data?
        if let dataAsString = data as? String {
            dataContainer = dataAsString.data(using: .utf8)
        } else if JSONSerialization.isValidJSONObject(data) {
            dataContainer = try JSONSerialization.data(withJSONObject: data)
        } else {
            throw SendDataMessageError.invalidData
        }

        if let container = dataContainer {
            if container.count > Constants.dataMessageMaxDataSizeInByte {
                throw SendDataMessageError.invalidDataLength
            }
            container.withUnsafeBytes { (bufferRawBufferPointer) -> Void in
                if let bufferPointer = bufferRawBufferPointer
                    .baseAddress {
                    videoClient?.sendDataMessage(topic,
                                                 data: bufferPointer.assumingMemoryBound(to: Int8.self),
                                                 lifetimeMs: lifetimeMs)
                }
            }
        } else {
            throw SendDataMessageError.invalidData
        }
    }
}
