//
//  MeetingEventClientConfiguration.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `MeetingEventClientConfiguration` is one type of `EventClientConfiguration` that contains
/// information about the meeting
@objcMembers public class MeetingEventClientConfiguration: NSObject, EventClientConfiguration {
    public let type: EventClientType
    public let eventClientJoinToken: String
    public var tag: String
    public var metadataAttributes: [String : Any]

    public init(eventClientJoinToken: String, meetingId: String, attendeeId: String) {
        self.type = .meet
        self.eventClientJoinToken = eventClientJoinToken
        self.tag = EventClientType.meet.description
        self.metadataAttributes = [
            EventAttributeName.meetingId.description: meetingId,
            EventAttributeName.attendeeId.description: attendeeId
        ]
    }
}
