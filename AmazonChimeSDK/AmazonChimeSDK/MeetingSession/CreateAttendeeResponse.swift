//
//  CreateMeetingResponse.swift
//  AmazonChimeSDK
//
//  Created by Wang, Haoran on 1/11/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

import Foundation

public struct CreateAttendeeResponse {
    var attendee: Attendee

    public init(attendee: Attendee) {
        self.attendee = attendee
    }
}

public struct Attendee {
    var attendeeId: String
    var joinToken: String

    public init(attendeeId: String, joinToken: String) {
        self.attendeeId = attendeeId
        self.joinToken = joinToken
    }
}
