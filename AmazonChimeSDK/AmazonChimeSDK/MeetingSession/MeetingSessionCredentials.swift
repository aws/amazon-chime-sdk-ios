//
//  MeetingSessionCredentials.swift
//  AmazonChimeSDK
//
//  Created by Wang, Haoran on 1/9/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

import Foundation

public struct MeetingSessionCredentials {
    var attendeeId: String
    var joinToken: String

    public init(attendeeId: String, joinToken: String) {
        self.attendeeId = attendeeId
        self.joinToken = joinToken
    }
}
