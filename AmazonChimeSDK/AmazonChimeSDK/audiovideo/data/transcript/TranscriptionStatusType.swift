//
//  TranscriptionStatusType.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// See [Using Amazon Chime SDK live transcription developer guide](https://docs.aws.amazon.com/chime/latest/dg/process-msgs.html) for details about transcription message types and data guidelines
@objc public enum TranscriptionStatusType: Int, Equatable, CustomStringConvertible {
    case unknown = 0
    case started = 1
    case interrupted = 2
    case resumed = 3
    case stopped = 4
    case failed = 5

    public var description: String {
        switch self {
        case .unknown:
            return "unknown"
        case .started:
            return "started"
        case .interrupted:
            return "interrupted"
        case .resumed:
            return "resumed"
        case .stopped:
            return "stopped"
        case .failed:
            return "failed"
        }
    }
}
