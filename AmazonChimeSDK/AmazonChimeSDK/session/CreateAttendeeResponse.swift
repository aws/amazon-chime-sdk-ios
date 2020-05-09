//
//  CreateAttendeeResponse.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
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
    let externalUserId: String
    let joinToken: String

    public init(attendeeId: String, externalUserId: String, joinToken: String) {
        self.attendeeId = attendeeId
        self.externalUserId = externalUserId
        self.joinToken = joinToken
    }
}
