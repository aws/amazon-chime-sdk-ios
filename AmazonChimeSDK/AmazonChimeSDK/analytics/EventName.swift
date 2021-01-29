//
//  EventName.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `EventName` represent some major event that could help builders to analyze the data
@objc public enum EventName: Int, CaseIterable, CustomStringConvertible {
    /// The camera selection failed.
    case videoInputFailed
    /// The meeting will start.
    case meetingStartRequested
    /// The meeting started.
    case meetingStartSucceeded
    /// The meeting failed to start.
    case meetingStartFailed
    /// The meeting ended with failure
    case meetingFailed
    /// The meeting ended.
    case meetingEnded

    public var description: String {
        switch self {
        case .videoInputFailed:
            return "videoInputFailed"
        case .meetingStartRequested:
            return "meetingStartRequested"
        case .meetingStartSucceeded:
            return "meetingStartSucceeded"
        case .meetingStartFailed:
            return "meetingStartFailed"
        case .meetingFailed:
            return "meetingFailed"
        case .meetingEnded:
            return "meetingEnded"
        }
    }
}
