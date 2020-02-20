//
//  DefaultMeetingSession.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import AVFoundation
import Foundation

public class DefaultMeetingSession: MeetingSession {
    public let configuration: MeetingSessionConfiguration
    public let logger: Logger
    public let audioVideo: AudioVideoFacade

    private let audioClient: AudioClient
    private let audioSession: AVAudioSession

    public init(configuration: MeetingSessionConfiguration, logger: Logger) {
        self.configuration = configuration
        self.logger = logger
        self.audioClient = AudioClient.sharedInstance()
        self.audioSession = AVAudioSession.sharedInstance()
        let clientMetricsCollector = DefaultClientMetricsCollector()
        let audioClientObserver = DefaultAudioClientObserver(audioClient: audioClient,
                                                             clientMetricsCollector: clientMetricsCollector)
        let audioClientController = DefaultAudioClientController(audioClient: audioClient,
                                                                 audioClientObserver: audioClientObserver,
                                                                 audioSession: audioSession)
        let videoTileController = DefaultVideoTileController(logger: logger)
        let videoClientController = DefaultVideoClientController(logger: logger, isUsing16by9AspectRatio: false)
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
