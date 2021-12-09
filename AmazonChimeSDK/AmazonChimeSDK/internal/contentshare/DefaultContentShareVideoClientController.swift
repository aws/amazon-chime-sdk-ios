//
//  DefaultContentShareVideoClientController.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDKMedia
import Foundation

@objcMembers public class DefaultContentShareVideoClientController: NSObject, ContentShareVideoClientController {
    private let configuration: MeetingSessionConfiguration
    private let logger: Logger
    private let clientMetricsCollector: ClientMetricsCollector
    private let videoClient: VideoClientProtocol
    private let contentShareObservers = ConcurrentMutableSet()
    private let videoSourceAdapter = VideoSourceAdapter()
    private let videoClientLock = NSLock()
    private var isSharing = false
    private let videoConfig: VideoConfiguration = {
        let config = VideoConfiguration()
        config.isUsing16by9AspectRatio = true
        config.isUsingSendSideBwe = true
        config.isDisablingSimulcastP2P = true
        config.isUsingPixelBufferRenderer = true
        config.isContentShare = true
        config.isUsingInbandTurnCreds = true
        return config
    }()

    public init(videoClient: VideoClientProtocol,
                configuration: MeetingSessionConfiguration,
                logger: Logger,
                clientMetricsCollector: ClientMetricsCollector) {
        self.configuration = configuration
        videoConfig.audioHostUrl = configuration.urls.audioHostUrl as NSString
        self.logger = logger
        self.clientMetricsCollector = clientMetricsCollector
        self.videoClient = videoClient
        super.init()
        videoClient.setReceiving(false)
    }

    public func startVideoShare(source: VideoSource) {
        videoClientLock.lock()
        defer { videoClientLock.unlock() }

        if !isSharing {
            startVideoClient()
        }
        videoSourceAdapter.source = source
        videoClient.setExternalVideoSource(videoSourceAdapter)
        videoClient.setSending(true)
    }

    public func stopVideoShare() {
        videoClientLock.lock()
        defer { videoClientLock.unlock() }

        if !isSharing {
            return
        }
        videoClient.setSending(false)
        stopVideoClient()
    }

    private func startVideoClient() {
        videoClient.delegate = self
        videoClient.start(configuration.meetingId,
                          token: configuration.credentials.joinToken,
                          sending: false,
                          config: videoConfig,
                          appInfo: DeviceUtils.getDetailedInfo(),
                          signalingUrl: configuration.urls.signalingUrl)
    }

    private func stopVideoClient() {
        videoClient.stop()
    }

    public func subscribeToVideoClientStateChange(observer: ContentShareObserver) {
        contentShareObservers.add(observer)
    }

    public func unsubscribeFromVideoClientStateChange(observer: ContentShareObserver) {
        contentShareObservers.remove(observer)
    }
}

extension DefaultContentShareVideoClientController: VideoClientDelegate {
    public func videoClientRequestTurnCreds(_ client: VideoClient?) {
        let turnControlUrl = configuration.urls.turnControlUrl
        let meetingId = configuration.meetingId
        let signalingUrl = configuration.urls.signalingUrl
        let joinTokenBase = DefaultModality(id: configuration.credentials.joinToken).base
        TURNRequestService.postTURNRequest(meetingId: meetingId,
                                           turnControlUrl: turnControlUrl,
                                           joinToken: joinTokenBase,
                                           logger: logger) { [weak self] turnCredentials in
            if let strongSelf = self, let turnCredentials = turnCredentials {
                let turnResponse = turnCredentials.toTURNSessionResponse(urlRewriter: strongSelf.configuration.urlRewriter,
                                                                         signalingUrl: signalingUrl)
                (strongSelf.videoClient as? VideoClient)?.updateTurnCreds(turnResponse, turn: VIDEO_CLIENT_TURN_FEATURE_ON)
            } else {
                self?.logger.error(msg: "Failed to update TURN Credentials")
            }
        }
    }

    public func videoClientIsConnecting(_ client: VideoClient?) {
        logger.info(msg: "ContentShare videoClientIsConnecting")
    }

    public func videoClientDidConnect(_ client: VideoClient?, controlStatus: Int32) {
        logger.info(msg: "ContentShare videoClientDidConnect")
        ObserverUtils.forEach(observers: contentShareObservers) { (observer: ContentShareObserver) in
            observer.contentShareDidStart()
        }
        isSharing = true
    }

    public func videoClientDidFail(_ client: VideoClient?, status: video_client_status_t, controlStatus: Int32) {
        logger.info(msg: "ContentShare videoClientDidFail")
        resetContentShareVideoClientMetrics()
        ObserverUtils.forEach(observers: contentShareObservers) { (observer: ContentShareObserver) in
            observer.contentShareDidStop(status: ContentShareStatus(statusCode: .videoServiceFailed))
        }
        isSharing = false
        cleanUp()
    }

    public func videoClientDidStop(_ client: VideoClient?) {
        logger.info(msg: "ContentShare videoClientDidStop")
        resetContentShareVideoClientMetrics()
        ObserverUtils.forEach(observers: contentShareObservers) { (observer: ContentShareObserver) in
            observer.contentShareDidStop(status: ContentShareStatus(statusCode: .ok))
        }
        isSharing = false
        cleanUp()
    }

    public func videoClientMetricsReceived(_ metrics: [AnyHashable: Any]?) {
        guard let metrics = metrics else { return }
        clientMetricsCollector.processContentShareVideoClientMetrics(metrics: metrics)
    }

    private func resetContentShareVideoClientMetrics() {
        clientMetricsCollector.processContentShareVideoClientMetrics(metrics: [:])
    }
    
    private func cleanUp() {
        videoClient.delegate = nil
    }
}
