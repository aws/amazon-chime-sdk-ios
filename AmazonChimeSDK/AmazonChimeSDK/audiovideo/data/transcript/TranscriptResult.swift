//
//  TranscriptResult.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// See [Using Amazon Chime SDK live transcription developer guide](https://docs.aws.amazon.com/chime/latest/dg/process-msgs.html) for details about transcription message types and data guidelines
@objcMembers public class TranscriptResult: NSObject {
    public let resultId: String
    public let channelId: String?
    public let isPartial: Bool
    public let startTimeMs: Int64
    public let endTimeMs: Int64
    public let alternatives: [TranscriptAlternative]
    public let languageCode: String?
    public let languageIdentification: [TranscriptLanguageWithScore]?

    public init(resultId: String,
                channelId: String?,
                isPartial: Bool,
                startTimeMs: Int64,
                endTimeMs: Int64,
                alternatives: [TranscriptAlternative],
                languageCode: String?,
                languageIdentification: [TranscriptLanguageWithScore]?) {
        self.resultId = resultId
        self.channelId = channelId
        self.isPartial = isPartial
        self.startTimeMs = startTimeMs
        self.endTimeMs = endTimeMs
        self.alternatives = alternatives
        self.languageCode = languageCode
        self.languageIdentification = languageIdentification
    }
}
