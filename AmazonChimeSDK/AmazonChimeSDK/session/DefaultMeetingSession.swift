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

    private let audioSession: AVAudioSession
    private let audioClient: AudioClient
    private let audioClientController: AudioClientController
    private let audioClientObserver: AudioClientObserver
    private let clientMetricsCollector: ClientMetricsCollector

    public init(configuration: MeetingSessionConfiguration, logger: Logger) {
        self.configuration = configuration
        self.logger = logger
        self.audioSession = AVAudioSession.sharedInstance()
        self.audioClient = AudioClient.sharedInstance()
        self.clientMetricsCollector = DefaultClientMetricsCollector()
        self.audioClientObserver = DefaultAudioClientObserver(audioClient: audioClient,
                                                              clientMetricsCollector: clientMetricsCollector)
        self.audioClientController = DefaultAudioClientController(audioClient: audioClient,
                                                                  audioClientObserver: audioClientObserver)
        self.audioVideo = DefaultAudioVideoFacade(
            audioVideoController: DefaultAudioVideoController(audioClientController: audioClientController,
                                                              audioClientObserver: audioClientObserver,
                                                              clientMetricsCollector: clientMetricsCollector,
                                                              configuration: configuration,
                                                              logger: logger),
            realtimeController: DefaultRealtimeController(audioClientController: audioClientController,
                                                          audioClientObserver: audioClientObserver),
            deviceController: DefaultDeviceController(audioSession: audioSession,
                                                      logger: logger)
        )
    }
}
