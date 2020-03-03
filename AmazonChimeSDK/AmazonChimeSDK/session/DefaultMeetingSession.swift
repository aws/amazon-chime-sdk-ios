//
//  DefaultMeetingSession.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import AVFoundation
import Foundation

@objcMembers public class DefaultMeetingSession: NSObject, MeetingSession {
    public let configuration: MeetingSessionConfiguration
    public let logger: Logger
    public let audioVideo: AudioVideoFacade

    private let audioClient: AudioClient = AudioClient.sharedInstance()
    private let audioSession = AVAudioSession.sharedInstance()

    public init(configuration: MeetingSessionConfiguration, logger: Logger) {
        self.configuration = configuration
        self.logger = logger

        let clientMetricsCollector = DefaultClientMetricsCollector()
        let audioClientObserver = DefaultAudioClientObserver(audioClient: audioClient,
                                                             clientMetricsCollector: clientMetricsCollector)
        let audioClientController = DefaultAudioClientController(audioClient: audioClient,
                                                                 audioClientObserver: audioClientObserver,
                                                                 audioSession: audioSession)

        let videoClientController = DefaultVideoClientController(logger: logger,
                                                                 clientMetricsCollector: clientMetricsCollector,
                                                                 isUsing16by9AspectRatio: false)
        let videoTileController =
            DefaultVideoTileController(logger: logger,
                                       videoClientController: videoClientController)
        videoClientController.subscribeToVideoTileControllerObservers(observer: videoTileController)

        self.audioVideo = DefaultAudioVideoFacade(
            audioVideoController: DefaultAudioVideoController(audioClientController: audioClientController,
                                                              audioClientObserver: audioClientObserver,
                                                              clientMetricsCollector: clientMetricsCollector,
                                                              videoClientController: videoClientController,
                                                              configuration: configuration,
                                                              logger: logger),
            realtimeController: DefaultRealtimeController(audioClientController: audioClientController,
                                                          audioClientObserver: audioClientObserver),
            deviceController: DefaultDeviceController(audioSession: audioSession,
                                                      videoClientController: videoClientController,
                                                      logger: logger),
            videoTileController: videoTileController)
    }
}
