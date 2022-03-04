//
//  TranscriptLanguageWithScore.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// See [Using Amazon Chime SDK live transcription developer guide](https://docs.aws.amazon.com/transcribe/latest/dg/lang-id.html) for details about transcription message types and data guidelines
@objcMembers public class TranscriptLanguageWithScore: NSObject {
    public let languageCode: String
    public let score: Double
  
    public init(languageCode: String, score: Double) {
        self.languageCode = languageCode
        self.score = score
    }
}
