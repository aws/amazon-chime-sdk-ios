//
//  CreateMeetingResponse.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

@objcMembers public class CreateAttendeeResponse: NSObject {
    let attendee: Attendee

    public init(attendee: Attendee) {
        self.attendee = attendee
    }
}

@objcMembers public class Attendee: NSObject {
    let attendeeId: String
    let joinToken: String

    public init(attendeeId: String, joinToken: String) {
        self.attendeeId = attendeeId
        self.joinToken = joinToken
    }
}
