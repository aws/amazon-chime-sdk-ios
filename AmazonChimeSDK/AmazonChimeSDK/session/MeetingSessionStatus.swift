//
//  MeetingSessionStatus.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `MeetingSessionStatus` indicates a status received regarding the session.
@objcMembers public class MeetingSessionStatus: NSObject {
    public let statusCode: MeetingSessionStatusCode

    public init(statusCode: MeetingSessionStatusCode) {
        self.statusCode = statusCode
    }
}
