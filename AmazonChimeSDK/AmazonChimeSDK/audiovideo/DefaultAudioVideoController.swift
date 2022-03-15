//
//  DefaultAudioVideoController.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AVFoundation
import Foundation

@objcMembers public class DefaultAudioVideoController: NSObject, AudioVideoControllerFacade {
    public let configuration: MeetingSessionConfiguration
    public let logger: Logger

    private let audioClientController: AudioClientController
    private let audioClientObserver: AudioClientObserver
    private let clientMetricsCollector: ClientMetricsCollector
    private var videoClientController: VideoClientController
    private let videoTileController: VideoTileController
    private var primaryMeetingPromotionObserver: PrimaryMeetingPromotionObserver?

    public init(audioClientController: AudioClientController,
                audioClientObserver: AudioClientObserver,
                clientMetricsCollector: ClientMetricsCollector,
                videoClientController: VideoClientController,
                videoTileController: VideoTileController,
                configuration: MeetingSessionConfiguration,
                logger: Logger) {
        self.audioClientController = audioClientController
        self.audioClientObserver = audioClientObserver
        self.clientMetricsCollector = clientMetricsCollector
        self.videoClientController = videoClientController
        self.videoTileController = videoTileController
        self.configuration = configuration
        self.logger = logger
    }

    public func start() throws {
        // By default, start for calls without CallKit integration. Use start(callKitEnabled:)
        // to override the default behavior if the call is integrated with CallKit
        try self.start(audioVideoConfiguration: AudioVideoConfiguration())
    }

    public func start(callKitEnabled: Bool) throws {
        try self.start(audioVideoConfiguration: AudioVideoConfiguration(callKitEnabled: callKitEnabled))
    }

    public func start(audioVideoConfiguration: AudioVideoConfiguration) throws {
        try audioClientController.start(audioFallbackUrl: configuration.urls.audioFallbackUrl,
                                        audioHostUrl: configuration.urls.audioHostUrl,
                                        meetingId: configuration.meetingId,
                                        attendeeId: configuration.credentials.attendeeId,
                                        joinToken: configuration.credentials.joinToken,
                                        callKitEnabled: audioVideoConfiguration.callKitEnabled,
                                        audioMode: audioVideoConfiguration.audioMode)
        videoClientController.subscribeToVideoTileControllerObservers(observer: videoTileController)
        videoClientController.start()
    }

    public func stop() {
        audioClientController.stop()
        videoClientController.stopAndDestroy()
    }

    public func addAudioVideoObserver(observer: AudioVideoObserver) {
        audioClientObserver.subscribeToAudioClientStateChange(observer: observer)
        videoClientController.subscribeToVideoClientStateChange(observer: observer)
    }

    public func removeAudioVideoObserver(observer: AudioVideoObserver) {
        audioClientObserver.unsubscribeFromAudioClientStateChange(observer: observer)
        videoClientController.unsubscribeFromVideoClientStateChange(observer: observer)
    }

    public func addMetricsObserver(observer: MetricsObserver) {
        clientMetricsCollector.subscribeToMetrics(observer: observer)
    }

    public func removeMetricsObserver(observer: MetricsObserver) {
        clientMetricsCollector.unsubscribeFromMetrics(observer: observer)
    }

    public func startLocalVideo() throws {
        try videoClientController.startLocalVideo()
    }

    public func startLocalVideo(source: VideoSource) {
        videoClientController.startLocalVideo(source: source)
    }

    public func stopLocalVideo() {
        videoClientController.stopLocalVideo()
    }

    public func startRemoteVideo() {
        videoClientController.startRemoteVideo()
    }

    public func stopRemoteVideo() {
        videoClientController.stopRemoteVideo()
    }
    
    public func updateVideoSourceSubscriptions(addedOrUpdated: Dictionary<RemoteVideoSource, VideoSubscriptionConfiguration>, removed: Array<RemoteVideoSource>) {
        videoClientController.updateVideoSourceSubscriptions(addedOrUpdated: addedOrUpdated, removed: removed)
    }

    public func promoteToPrimaryMeeting(
        credentials: MeetingSessionCredentials,
        observer: PrimaryMeetingPromotionObserver) {
        let group = DispatchGroup()
        var videoClientPromotionStatus: MeetingSessionStatus?
        let videoClientPromotionCallback = { (status: MeetingSessionStatus) -> Void in
            self.logger.info(
                msg: "Video primary meeting promotion has completed with status \(status.statusCode.description)")
            videoClientPromotionStatus = status
            group.leave()
        }
        let videoClientDemotionCallback = { (status: MeetingSessionStatus) -> Void in
            self.logger.info(
                msg: "Video primary meeting demotion has completed with status \(status.statusCode.description)")
            self.audioClientController.demoteFromPrimaryMeeting()
            observer.didDemoteFromPrimaryMeeting(status: status)
        }
        group.enter()
        var audioClientPromotionStatus: MeetingSessionStatus?
        let audioClientPromotionCallback = { (status: MeetingSessionStatus) -> Void in
            self.logger.info(
                msg: "Audio primary meeting promotion has completed with status \(status.statusCode.description)")
            audioClientPromotionStatus = status
            group.leave()
        }
        let audioClientDemotionCallback = { (status: MeetingSessionStatus) -> Void in
            self.logger.info(
                msg: "Audio primary meeting demotion has completed with status \(status.statusCode.description)")
            self.videoClientController.demoteFromPrimaryMeeting()
            observer.didDemoteFromPrimaryMeeting(status: status)
        }
        group.enter()

        // In these observers we try demoting the other client. Note that the individual controllers
        // do not follow the exact same pattern of calling back on observer (with `MeetingSessionStatusCode.OK` in
        // the case of explicit demotion request so we don't need to worry about any infinite loops
        class PrimaryMeetingPromotionObserverAdapter: PrimaryMeetingPromotionObserver {
            var promotionCallback: (MeetingSessionStatus) -> Void
            var demotionCallback: (MeetingSessionStatus) -> Void

            init(promotionCallback: @escaping (MeetingSessionStatus) -> Void,
                demotionCallback: @escaping (MeetingSessionStatus) -> Void) {
                self.promotionCallback = promotionCallback
                self.demotionCallback = demotionCallback
            }

            func didPromoteToPrimaryMeeting(status: MeetingSessionStatus) {
                self.promotionCallback(status)
            }

            func didDemoteFromPrimaryMeeting(status: MeetingSessionStatus) {
                self.demotionCallback(status)
            }
        }
        let videoClientPromotionObserverAdapter = PrimaryMeetingPromotionObserverAdapter(
            promotionCallback: videoClientPromotionCallback,
            demotionCallback: videoClientDemotionCallback)
        let audioClientPromotionObserverAdapter = PrimaryMeetingPromotionObserverAdapter(
            promotionCallback: audioClientPromotionCallback,
            demotionCallback: audioClientDemotionCallback)
        primaryMeetingPromotionObserver = observer // Store for demotion
        videoClientController.promoteToPrimaryMeeting(credentials: credentials,
                                                      observer: videoClientPromotionObserverAdapter)
        audioClientController.promoteToPrimaryMeeting(credentials: credentials,
                                                        observer: audioClientPromotionObserverAdapter)
            
        group.notify(queue: DispatchQueue.main) {
            if let videoClientStatus = videoClientPromotionStatus, let audioClientStatus = audioClientPromotionStatus {
                // Mux the statuses together, single failure is total failure
                if videoClientStatus.statusCode != MeetingSessionStatusCode.ok {
                    self.audioClientController.demoteFromPrimaryMeeting() // Leave other controller
                    observer.didPromoteToPrimaryMeeting(status: videoClientStatus)
                } else if audioClientStatus.statusCode != MeetingSessionStatusCode.ok {
                    self.videoClientController.demoteFromPrimaryMeeting()  // Leave other controller
                    observer.didPromoteToPrimaryMeeting(status: audioClientStatus)
                } else {
                    observer.didPromoteToPrimaryMeeting(status: videoClientStatus) // Just use video client status
                }
            }
        }
    }

    public func demoteFromPrimaryMeeting() {
        videoClientController.demoteFromPrimaryMeeting()
        audioClientController.demoteFromPrimaryMeeting()
        primaryMeetingPromotionObserver?.didDemoteFromPrimaryMeeting(
            status: MeetingSessionStatus(statusCode: MeetingSessionStatusCode.ok))
    }
}
