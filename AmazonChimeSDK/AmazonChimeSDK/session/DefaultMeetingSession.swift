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
    public let configuration: MeetingSessionConfiguration
    public let logger: Logger
    public let audioVideo: AudioVideoFacade

    private let audioSession = AVAudioSession.sharedInstance()

    public init(configuration: MeetingSessionConfiguration, logger: Logger) {
        self.configuration = configuration
        self.logger = logger
        VideoClient.globalInitialize()
        let audioClient: AudioClient = DefaultAudioClient(logger: logger)
        let videoClient: VideoClient = DefaultVideoClient(logger: logger)
        let clientMetricsCollector = DefaultClientMetricsCollector()
        let audioClientObserver = DefaultAudioClientObserver(audioClient: audioClient,
                                                             clientMetricsCollector: clientMetricsCollector)
        let audioClientController = DefaultAudioClientController(audioClient: audioClient,
                                                                 audioClientObserver: audioClientObserver,
                                                                 audioSession: audioSession)
        let videoClientController = DefaultVideoClientController(videoClient: videoClient,
                                                                 logger: logger,
                                                                 clientMetricsCollector: clientMetricsCollector)
        let videoTileController =
            DefaultVideoTileController(logger: logger,
                                       videoClientController: videoClientController)
        videoClientController.subscribeToVideoTileControllerObservers(observer: videoTileController)
        let realtimeController = DefaultRealtimeController(audioClientController: audioClientController,
                                                           audioClientObserver: audioClientObserver)
        let activeSpeakerDetector =
            DefaultActiveSpeakerDetector(audioClientObserver: audioClientObserver,
                                         selfAttendeeId: self.configuration.credentials.attendeeId)
        self.audioVideo =
            DefaultAudioVideoFacade(audioVideoController:
                    DefaultAudioVideoController(audioClientController: audioClientController,
                                                audioClientObserver: audioClientObserver,
                                                clientMetricsCollector: clientMetricsCollector,
                                                videoClientController: videoClientController,
                                                configuration: configuration,
                                                logger: logger),
                                    realtimeController: realtimeController,
                                    deviceController:
                                        DefaultDeviceController(
                                            audioSession: audioSession,
                                            videoClientController: videoClientController,
                                            logger: logger
                                        ),
                                    videoTileController: videoTileController,
                                    activeSpeakerDetector: activeSpeakerDetector)
    }
}
