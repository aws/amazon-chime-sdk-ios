//
//  TranscriptEntity.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// See [Using Amazon Chime SDK live transcription developer guide](https://docs.aws.amazon.com/chime/latest/dg/process-msgs.html) for details about transcription message types and data guidelines
@objcMembers public class TranscriptEntity: NSObject {
    public let type: String
    public let content: String
    public let category: String
    public let confidence: Double?
    public let startTimeMs: Int64
    public let endTimeMs: Int64

    public init(type: String,
                content: String,
                category: String,
                confidence: Double?,
                startTimeMs: Int64,
                endTimeMs: Int64) {
        self.type = type
        self.content = content
        self.category = category
        self.confidence = confidence
        self.startTimeMs = startTimeMs
        self.endTimeMs = endTimeMs
    }
}
