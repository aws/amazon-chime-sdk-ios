//
//  TranscriptSpeaker.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers public class TranscriptSpeaker: NSObject {
    public let attendeeId: String
    public let externalUserId: String

    public init(attendeeId: String, externalUserId: String) {
        self.attendeeId = attendeeId
        self.externalUserId = externalUserId
    }
}
