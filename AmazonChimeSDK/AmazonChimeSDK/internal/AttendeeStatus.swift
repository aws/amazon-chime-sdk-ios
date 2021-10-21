//
//  AttendeeStatus.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `AttendeeStatus` describes the status of attendee
@objc public enum AttendeeStatus: Int, CaseIterable, CustomStringConvertible {
    /// The attendee joined
    case joined = 1

    /// The attendee left
    case left = 2

    /// The attendee dropped due to network issues
    case dropped = 3

    /// The attendee joined without audio
    case joinedNoAudio = 4

    public var description: String {
        switch self {
        case .joined:
            return "joined"
        case .left:
            return "left"
        case .dropped:
            return "dropped"
        case .joinedNoAudio:
            return "joinedNoAudio"
        }
    }
}
