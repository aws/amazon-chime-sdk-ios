//
//  SDKEvent.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `SDKEvent` defines event that composes of name of event and attribute to describe the event
@objcMembers public class SDKEvent: NSObject {
    public let name: String
    public let eventAttributes: [AnyHashable: Any]

    public init(meetingHistoryEventName: MeetingHistoryEventName, eventAttributes: [AnyHashable: Any]) {
        self.name = String(describing: meetingHistoryEventName)
        self.eventAttributes = eventAttributes
    }

    public init(eventName: EventName, eventAttributes: [AnyHashable: Any]) {
        self.name = String(describing: eventName)
        self.eventAttributes = eventAttributes
    }
}
