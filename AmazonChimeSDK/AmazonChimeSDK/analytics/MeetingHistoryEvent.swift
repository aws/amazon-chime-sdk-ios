//
//  MeetingHistoryEvent.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers public class MeetingHistoryEvent: NSObject {
    public let meetingHistoryEventName: MeetingHistoryEventName
    public let timestampMs: Int64

    public init(meetingHistoryEventName: MeetingHistoryEventName, timestampMs: Int64) {
        self.meetingHistoryEventName = meetingHistoryEventName
        self.timestampMs = timestampMs
    }

    public override var description: String {
        return "\(String(describing: meetingHistoryEventName)): \(timestampMs)"
    }
}
