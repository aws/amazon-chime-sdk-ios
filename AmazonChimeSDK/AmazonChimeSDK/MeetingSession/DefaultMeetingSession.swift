//
//  DefaultMeetingSession.swift
//  AmazonChimeSDK
//
//  Created by Wang, Haoran on 1/10/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

import Foundation

public class DefaultMeetingSession: MeetingSession {
    public var configuration: MeetingSessionConfiguration
    public var logger: Logger

    public init(configuration: MeetingSessionConfiguration, logger: Logger) {
        self.configuration = configuration
        self.logger = logger
    }
}
