//
//  TranscriptItem.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// See [Using Amazon Chime SDK live transcription developer guide](https://docs.aws.amazon.com/chime/latest/dg/process-msgs.html) for more details about transcription message types and data guidelines
@objcMembers public class TranscriptItem: NSObject {
    public let type: TranscriptItemType
    public let startTimeMs: Int64
    public let endTimeMs: Int64
    public let attendee: AttendeeInfo
    public let content: String
    public let vocabularyFilterMatch: Bool

    public init(type: TranscriptItemType,
                startTimeMs: Int64,
                endTimeMs: Int64,
                attendee: AttendeeInfo,
                content: String,
                vocabularyFilterMatch: Bool) {
        self.type = type
        self.startTimeMs = startTimeMs
        self.endTimeMs = endTimeMs
        self.attendee = attendee
        self.content = content
        self.vocabularyFilterMatch = vocabularyFilterMatch
    }
}
