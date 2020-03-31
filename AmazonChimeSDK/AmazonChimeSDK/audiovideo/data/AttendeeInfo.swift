//
//  AttendeeInfo.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers public class AttendeeInfo: NSObject, Comparable {
    public let attendeeId: String
    public let externalUserId: String

    init(attendeeId: String, externalUserId: String) {
        self.attendeeId = attendeeId
        self.externalUserId = externalUserId
    }

    override public func isEqual(_ object: Any?) -> Bool {
        if let other = object as? AttendeeInfo {
            return self.attendeeId == other.attendeeId
        }
        return false
    }

    override public var hash: Int {
        return attendeeId.hashValue
    }

    public static func < (lhs: AttendeeInfo, rhs: AttendeeInfo) -> Bool {
        return lhs.attendeeId < rhs.attendeeId
    }
}
