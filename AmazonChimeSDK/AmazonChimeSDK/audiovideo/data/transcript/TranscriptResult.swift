//
//  TranscriptResult.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers public class TranscriptResult: NSObject {
    public let resultId: String
    public let channelId: String?
    public let isPartial: Bool
    public let startTimeMs: Int64
    public let endTimeMs: Int64
    public let alternatives: [TranscriptAlternative]

    public init(resultId: String,
                channelId: String?,
                isPartial: Bool,
                startTimeMs: Int64,
                endTimeMs: Int64,
                alternatives: [TranscriptAlternative]) {
        self.resultId = resultId
        self.channelId = channelId
        self.isPartial = isPartial
        self.startTimeMs = startTimeMs
        self.endTimeMs = endTimeMs
        self.alternatives = alternatives
    }
}
