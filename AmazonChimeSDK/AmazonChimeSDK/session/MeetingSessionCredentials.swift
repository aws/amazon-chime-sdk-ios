//
//  MeetingSessionCredentials.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

/// `MeetingSessionCredentials` includes the credentials used to authenticate.
/// the attendee on the meeting
@objcMembers public class MeetingSessionCredentials: NSObject {
    /// The attendee id for these credentials.
    public let attendeeId: String

    /// The token that the session will be authenticated with
    public let joinToken: String

    public init(attendeeId: String, joinToken: String) {
        self.attendeeId = attendeeId
        self.joinToken = joinToken
    }
}
