//
//  VolumeLevel.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `VolumeLevel` describes the volume level of an attendee for audio.
@objc public enum VolumeLevel: Int, CaseIterable, CustomStringConvertible {
    /// The attendee is muted
    case muted = -1

    /// The attendee is not speaking
    case notSpeaking = 0

    /// The attendee is speaking at low volume
    case low = 1

    /// The attendee is speaking at medium volume
    case medium = 2

    /// The attendee is speaking at high volume
    case high = 3

    public var description: String {
        switch self {
        case .muted:
            return "muted"
        case .notSpeaking:
            return "notSpeaking"
        case .low:
            return "low"
        case .medium:
            return "medium"
        case .high:
            return "high"
        }
    }
}
