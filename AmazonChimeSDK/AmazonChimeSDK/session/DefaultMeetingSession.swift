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

    private let audioSession = AVAudioSession.sharedInstance()

    public init(configuration: MeetingSessionConfiguration, logger: Logger) {
        self.configuration = configuration
        self.logger = logger
        VideoClient.globalInitialize()
        let audioClient: DefaultAudioClient = DefaultAudioClient.shared(logger: logger)
        let videoClient: VideoClient = DefaultVideoClient(logger: logger)
        let clientMetricsCollector = DefaultClientMetricsCollector()
        let audioClientLock = NSLock()

        let audioClientObserver = DefaultAudioClientObserver(audioClient: audioClient,
                                                             clientMetricsCollector: clientMetricsCollector,
                                                             audioClientLock: audioClientLock,
                                                             configuration: configuration)
        let audioClientController = DefaultAudioClientController(audioClient: audioClient,
                                                                 audioClientObserver: audioClientObserver,
                                                                 audioSession: audioSession,
                                                                 audioClientLock: audioClientLock)
        let videoClientController = DefaultVideoClientController(videoClient: videoClient,
                                                                 clientMetricsCollector: clientMetricsCollector,
                                                                 configuration: configuration,
                                                                 logger: logger)
        let videoTileController =
            DefaultVideoTileController(videoClientController: videoClientController,
                                       logger: logger)
        videoClientController.subscribeToVideoTileControllerObservers(observer: videoTileController)
        let realtimeController = DefaultRealtimeController(audioClientController: audioClientController,
                                                           audioClientObserver: audioClientObserver,
                                                           videoClientController: videoClientController)
        let activeSpeakerDetector =
            DefaultActiveSpeakerDetector(audioClientObserver: audioClientObserver,
                                         selfAttendeeId: configuration.credentials.attendeeId)
        audioVideo =
            DefaultAudioVideoFacade(audioVideoController:
                DefaultAudioVideoController(audioClientController: audioClientController,
                                            audioClientObserver: audioClientObserver,
                                            clientMetricsCollector: clientMetricsCollector,
                                            videoClientController: videoClientController,
                                            configuration: configuration,
                                            logger: logger),
                realtimeController: realtimeController,
                deviceController:
                DefaultDeviceController(audioSession: audioSession,
                                        videoClientController: videoClientController,
                                        logger: logger),
                videoTileController: videoTileController,
                activeSpeakerDetector: activeSpeakerDetector)
    }
}
