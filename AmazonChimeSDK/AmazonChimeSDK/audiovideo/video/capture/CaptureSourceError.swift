//
//  CaptureSourceError.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `CaptureSourceError` describes an error resulting from a capture source failure.
/// These can be used to trigger UI, or attempt to restart the capture source.
@objc public enum CaptureSourceError: Int {
    /// Unknown error, and catch-all for errors not otherwise covered.
    case unknown = 0

    /// A  failure observed from a system API used for capturing.
    case systemFailure = 1

    /// A failure observed during configuration.
    case configurationFailure = 2

    /// A temporary failure observed when capture source generates an invalid frame which is ignored.
    case invalidFrame = 3

    var description: String {
        switch self {
        case .unknown:
            return "unknown"
        case .systemFailure:
            return "systemFailure"
        case .configurationFailure:
            return "configurationFailure"
        case .invalidFrame:
            return "invalidFrame"
        }
    }
}
