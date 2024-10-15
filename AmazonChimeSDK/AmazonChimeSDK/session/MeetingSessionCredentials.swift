//
//  MeetingSessionCredentials.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `MeetingSessionCredentials` includes the credentials used to authenticate.
/// the attendee on the meeting
@objcMembers public class MeetingSessionCredentials: NSObject, Codable {
    /// The attendee id for these credentials.
    public let attendeeId: String

    /// The external user Id associated with the attendee.
    public let externalUserId: String

    /// The token that the session will be authenticated with.
    public let joinToken: String

    public init(attendeeId: String, externalUserId: String, joinToken: String) {
        self.attendeeId = attendeeId
        self.externalUserId = externalUserId
        self.joinToken = joinToken
    }
}
