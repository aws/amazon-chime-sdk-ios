//
//  MeetingSessionCredentials.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

@objcMembers public class MeetingSessionCredentials: NSObject {
    public let attendeeId: String
    public let joinToken: String

    public init(attendeeId: String, joinToken: String) {
        self.attendeeId = attendeeId
        self.joinToken = joinToken
    }
}
