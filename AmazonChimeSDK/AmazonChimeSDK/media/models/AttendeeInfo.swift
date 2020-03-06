//
//  AttendeeInfo.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
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
        } else {
            return false
        }
    }

    override public var hash: Int {
        return attendeeId.hashValue
    }

    public static func < (lhs: AttendeeInfo, rhs: AttendeeInfo) -> Bool {
        return lhs.attendeeId < rhs.attendeeId
    }
}
