//
//  TranscriptItemType.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// See [Using Amazon Chime SDK live transcription developer guide](https://docs.aws.amazon.com/chime/latest/dg/process-msgs.html) for details about transcription message types and data guidelines
@objc public enum TranscriptItemType: Int, CaseIterable, CustomStringConvertible {
    case unknown = 0
    case pronunciation = 1
    case punctuation = 2

    public var description: String {
        switch self {
        case .unknown:
            return "unknown"
        case .pronunciation:
            return "pronunciation"
        case .punctuation:
            return "punctuation"
        }
    }
}
