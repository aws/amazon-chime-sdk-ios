//
//  DefaultMeetingSession.swift
//  AmazonChimeSDK
//
//  Created by Wang, Haoran on 1/10/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

import Foundation

public class DefaultMeetingSession: MeetingSession {
    public let configuration: MeetingSessionConfiguration
    public let logger: Logger
    public let audioVideo: AudioVideoFacade

    public init(configuration: MeetingSessionConfiguration, logger: Logger
    ) {
        self.configuration = configuration
        self.logger = logger
        self.audioVideo = DefaultAudioVideoFacade(
            audioVideoController: DefaultAudioVideoController(configuration: configuration, logger: logger),
            realtimeController: DefaultRealtimeController()
        )
    }
}
