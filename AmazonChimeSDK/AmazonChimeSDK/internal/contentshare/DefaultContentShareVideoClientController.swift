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
    private let eventAnalyticsController: EventAnalyticsController
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
    private var videoSendCodecPreferences: [VideoCodecCapability] = [
        VideoCodecCapability.vp9(),
        VideoCodecCapability.h264ConstrainedBaselineProfile(),
        VideoCodecCapability.vp8()
    ]

    public init(videoClient: VideoClientProtocol,
                configuration: MeetingSessionConfiguration,
                logger: Logger,
                clientMetricsCollector: ClientMetricsCollector,
                eventAnalyticsController: EventAnalyticsController) {
        self.configuration = configuration
        videoConfig.audioHostUrl = configuration.urls.audioHostUrl as NSString
        self.logger = logger
        self.clientMetricsCollector = clientMetricsCollector
        self.videoClient = videoClient
        self.eventAnalyticsController = eventAnalyticsController
        super.init()
        videoClient.setReceiving(false)
    }

    public func startVideoShare(source: VideoSource) {
        logger.info(msg: "Starting video share with video source")
        startVideoShare(source: source, config: LocalVideoConfiguration())
    }

    public func startVideoShare(source: VideoSource, config: LocalVideoConfiguration) {
        if (self.configuration.meetingFeatures.contentMaxResolution == VideoResolution.videoDisabled) {
            logger.info(msg: "Could not start content share because content max resolution is set to disabled")
            return
        }
        eventAnalyticsController.publishEvent(name: .contentShareStartRequested)
        
        // ignore simulcast in config because contentshare does not have simulcast
        videoClientLock.lock()
        defer { videoClientLock.unlock() }

        if !isSharing {
            startVideoClient()
        }
        videoSourceAdapter.source = source
        let isContentResolutionUHD: Bool = (configuration.meetingFeatures.contentMaxResolution == VideoResolution.videoResolutionUHD)

        videoClient.setContentMaxResolutionUHD(isContentResolutionUHD)
        videoClient.setExternalVideoSource(videoSourceAdapter)
        videoClient.setSending(true)

        if config.maxBitRateKbps > 0 {
            logger.info(msg: "Setting max bit rate in kbps for content share")
            videoClient.setMaxBitRateKbps(config.maxBitRateKbps)
        }

        if (isContentResolutionUHD) {
            logger.info(msg: "Setting max bit rate in kbps for content share UHD (2500kbps)")
            videoClient.setMaxBitRateKbps(VideoBitrateConstants().contentHighResolutionBitrateKbps)
        }

        var codecCapabilties = [VideoCodecCapabilitiesInternal]()
        videoSendCodecPreferences.forEach { preference in codecCapabilties.append(
            VideoCodecCapabilitiesInternal(
                name: preference.name,
                clockRate: preference.clockRate,
                parameters: preference.parameters as [AnyHashable: Any]
            )
        )}
        videoClient.setVideoCodecPreferences(codecCapabilties)
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
        eventAnalyticsController.publishEvent(name: .contentShareStarted)
        ObserverUtils.forEach(observers: contentShareObservers) { (observer: ContentShareObserver) in
            observer.contentShareDidStart()
        }
        isSharing = true
    }

    public func videoClientDidFail(_ client: VideoClient?, status: video_client_status_t, controlStatus: Int32) {
        logger.error(msg: "ContentShare videoClientDidFail with status: \(status), contentStatus: \(controlStatus)")
        
        eventAnalyticsController.publishEvent(name: .contentShareFailed, attributes: [
            EventAttributeName.contentShareError: VideoClientFailedError(from: status)
        ])
        
        resetContentShareVideoClientMetrics()
        ObserverUtils.forEach(observers: contentShareObservers) { (observer: ContentShareObserver) in
            observer.contentShareDidStop(status: ContentShareStatus(statusCode: .videoServiceFailed))
        }
        isSharing = false
    }

    public func videoClientDidStop(_ client: VideoClient?) {
        logger.info(msg: "ContentShare videoClientDidStop")
        eventAnalyticsController.publishEvent(name: .contentShareStopped)
        resetContentShareVideoClientMetrics()
        ObserverUtils.forEach(observers: contentShareObservers) { (observer: ContentShareObserver) in
            observer.contentShareDidStop(status: ContentShareStatus(statusCode: .ok))
        }
        isSharing = false
    }
    
    public func videoClient(_ client: VideoClient, didReceive event: video_client_event) {
        logger.info(msg: "ContentShare didReceiveEvent: \(event.event_type)")
        if (event.event_type == VIDEO_CLIENT_EVENT_TYPE_SIGNALING_DROPPED) {
            logger.error(msg: "event: \(event.event_type) error: \(event.signaling_dropped_error)")
            eventAnalyticsController.publishEvent(name: .contentShareSignalingDropped, attributes: [
                EventAttributeName.signalingDroppedError: SignalingDroppedError(from: event.signaling_dropped_error)
            ])
        } else if (event.event_type == VIDEO_CLIENT_EVENT_TYPE_SIGNALING_OPENED) {
            eventAnalyticsController.publishEvent(name: .contentShareSignalingOpened,
                                                  attributes: [
                                                    EventAttributeName.signalingOpenDurationMs: event.signaling_open_duration_ms
                                                  ])
        } else if (event.event_type == VIDEO_CLIENT_EVENT_TYPE_ICE_GATHERING_COMPLETED) {
            eventAnalyticsController.publishEvent(name: .contentShareIceGatheringCompleted,
                                                  attributes: [
                                                    EventAttributeName.iceGatheringDurationMs: event.ice_gathering_duration_ms
                                                  ])
        }
    }

    public func videoClientMetricsReceived(_ metrics: [AnyHashable: Any]?) {
        guard let metrics = metrics else { return }
        clientMetricsCollector.processContentShareVideoClientMetrics(metrics: metrics)
    }

    public func setVideoCodecSendPreferences(preferences: [VideoCodecCapability]) {
        videoSendCodecPreferences = preferences
    }

    private func resetContentShareVideoClientMetrics() {
        clientMetricsCollector.processContentShareVideoClientMetrics(metrics: [:])
    }
}
