//
//  CreateMeetingResponse.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

public struct CreateAttendeeResponse {
    let attendee: Attendee

    public init(attendee: Attendee) {
        self.attendee = attendee
    }
}

public struct Attendee {
    let attendeeId: String
    let joinToken: String

    public init(attendeeId: String, joinToken: String) {
        self.attendeeId = attendeeId
        self.joinToken = joinToken
    }
}
