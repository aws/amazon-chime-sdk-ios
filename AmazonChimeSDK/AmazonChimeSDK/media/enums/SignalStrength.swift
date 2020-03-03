//
//  SignalStrength.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

/// SignalStrength describes the signal strength of an attendee for audio
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
