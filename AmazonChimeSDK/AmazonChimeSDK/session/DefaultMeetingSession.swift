//
//  DefaultMeetingSession.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDKMedia
import AVFoundation
import Foundation

@objcMembers public class DefaultMeetingSession: NSObject, MeetingSession {
    public let audioVideo: AudioVideoFacade
    public let configuration: MeetingSessionConfiguration
    public let logger: Logger
    public let eventAnalyticsController: EventAnalyticsController

    private let audioSession = AVAudioSession.sharedInstance()

    public init(configuration: MeetingSessionConfiguration,
                logger: Logger,
                eventReporterFactory: EventReporterFactory) {
        self.configuration = configuration
        self.logger = logger
        VideoClient.globalInitialize()
        let audioClient: DefaultAudioClient = DefaultAudioClient.shared(logger: logger)
        let videoClient: VideoClient = DefaultVideoClient(logger: logger)
        let clientMetricsCollector = DefaultClientMetricsCollector()
        let audioClientLock = NSLock()

        let meetingStatsCollector =  DefaultMeetingStatsCollector(logger: logger)

        self.eventAnalyticsController = DefaultEventAnalyticsController(meetingSessionConfig: configuration,
                                                                        meetingStatsCollector: meetingStatsCollector,
                                                                        logger: logger,
                                                                        eventReporter: eventReporterFactory.createEventReporter())
        let audioClientObserver = DefaultAudioClientObserver(audioClient: audioClient,
                                                             clientMetricsCollector: clientMetricsCollector,
                                                             audioClientLock: audioClientLock,
                                                             configuration: configuration,
                                                             logger: logger,
                                                             eventAnalyticsController: self.eventAnalyticsController,
                                                             meetingStatsCollector: meetingStatsCollector)
        let activeSpeakerDetector =
            DefaultActiveSpeakerDetector(selfAttendeeId: configuration.credentials.attendeeId)
        let audioClientController = DefaultAudioClientController(audioClient: audioClient,
                                                                 audioClientObserver: audioClientObserver,
                                                                 audioSession: audioSession,
                                                                 audioClientLock: audioClientLock,
                                                                 eventAnalyticsController: self.eventAnalyticsController,
                                                                 meetingStatsCollector: meetingStatsCollector,
                                                                 activeSpeakerDetector: activeSpeakerDetector,
                                                                 logger: logger)
        let videoClientController = DefaultVideoClientController(videoClient: videoClient,
                                                                 clientMetricsCollector: clientMetricsCollector,
                                                                 configuration: configuration,
                                                                 logger: logger,
                                                                 eventAnalyticsController: self.eventAnalyticsController)
        let videoTileController =
            DefaultVideoTileController(videoClientController: videoClientController,
                                       logger: logger,
                                       meetingStatsCollector: meetingStatsCollector)
        let realtimeController = DefaultRealtimeController(audioClientController: audioClientController,
                                                           audioClientObserver: audioClientObserver,
                                                           videoClientController: videoClientController)

        let contentModality = String(DefaultModality.separator) + String(describing: ModalityType.content)
        let contentShareCredentials = MeetingSessionCredentials(
            attendeeId: configuration.credentials.attendeeId + contentModality,
            externalUserId: configuration.credentials.externalUserId,
            joinToken: configuration.credentials.joinToken + contentModality)
        let contentShareConfiguration = MeetingSessionConfiguration(meetingId: configuration.meetingId,
                                                                    externalMeetingId: configuration.externalMeetingId,
                                                                    credentials: contentShareCredentials,
                                                                    urls: configuration.urls,
                                                                    urlRewriter: configuration.urlRewriter)
        let contentShareVideoClient = DefaultVideoClient(logger: logger)
        let contentShareVideoClientController = DefaultContentShareVideoClientController(videoClient: contentShareVideoClient,
                                                                                         configuration: contentShareConfiguration,
                                                                                         logger: logger,
                                                                                         clientMetricsCollector: clientMetricsCollector)
        let contentShareController = DefaultContentShareController(contentShareVideoClientController: contentShareVideoClientController)

        self.audioVideo =
            DefaultAudioVideoFacade(audioVideoController:
                DefaultAudioVideoController(audioClientController: audioClientController,
                                            audioClientObserver: audioClientObserver,
                                            clientMetricsCollector: clientMetricsCollector,
                                            videoClientController: videoClientController,
                                            videoTileController: videoTileController,
                                            configuration: configuration,
                                            logger: logger),
                                    realtimeController: realtimeController,
                                    deviceController:
                DefaultDeviceController(audioSession: audioSession,
                                        videoClientController: videoClientController,
                                        eventAnalyticsController: eventAnalyticsController,
                                        logger: logger),
                                    videoTileController: videoTileController,
                                    activeSpeakerDetector: activeSpeakerDetector,
                                    contentShareController: contentShareController,
                                    eventAnalyticsController: self.eventAnalyticsController,
                                    meetingStatsCollector: meetingStatsCollector)
    }

    public convenience init(configuration: MeetingSessionConfiguration,
                            logger: Logger) {
        let ingestionConfiguration = IngestionConfigurationBuilder().build(disabled: configuration.urls.ingestionUrl?.isEmpty != false,
                                                                           ingestionUrl: configuration.urls.ingestionUrl ?? "",
                                                                           clientConiguration: MeetingEventClientConfiguration(eventClientJoinToken: configuration.credentials.joinToken,
                                                                                                                               meetingId: configuration.meetingId,
                                                                                                                               attendeeId: configuration.credentials.attendeeId)
        )
        self.init(configuration: configuration,
                  logger: logger,
                  eventReporterFactory: DefaultMeetingEventReporterFactory(ingestionConfiguration: ingestionConfiguration,
                                                                    logger: logger))
    }
}
