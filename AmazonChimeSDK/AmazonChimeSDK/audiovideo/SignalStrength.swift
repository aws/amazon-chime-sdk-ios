//
//  SignalStrength.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `SignalStrength` describes the signal strength of an attendee for audio.
@objc public enum SignalStrength: Int, CaseIterable, CustomStringConvertible {
    /// The attendee has no signal
    case none = 0

    /// The attendee has low signal
    case low = 1

    /// The attendee has high signal
    case high = 2

    public var description: String {
        switch self {
        case .none:
            return "none"
        case .low:
            return "low"
        case .high:
            return "high"
        }
    }
}
