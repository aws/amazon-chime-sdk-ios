//
//  DefaultMeetingSession.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

public class DefaultMeetingSession: MeetingSession {
    public let configuration: MeetingSessionConfiguration
    public let logger: Logger
    public let audioVideo: AudioVideoFacade

    public init(configuration: MeetingSessionConfiguration, logger: Logger) {
        self.configuration = configuration
        self.logger = logger
        let videoTileController = DefaultVideoTileController(logger: logger)
        self.audioVideo = DefaultAudioVideoFacade(
            audioVideoController: DefaultAudioVideoController(configuration: configuration,
                                                              logger: logger,
                                                              videoTileController: videoTileController),
            realtimeController: DefaultRealtimeController(),
            deviceController: DefaultDeviceController(logger: logger),
            videoTileController: videoTileController
        )
    }
}
