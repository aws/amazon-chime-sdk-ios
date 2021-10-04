//
//  TranscriptItemType.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

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
