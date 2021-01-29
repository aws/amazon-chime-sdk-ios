//
//  MeetingHistoryEventName.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `MeetingHistoryEventName` is a meeting history state which are important events to note in the history.
/// Thus, this also includes events in `EventName`
@objc public enum MeetingHistoryEventName: Int, CaseIterable, CustomStringConvertible {

    /// The microphone was selected.
    case audioInputSelected
    /// The camera was selected.
    case videoInputSelected
    /// The camera selection failed.
    case videoInputFailed
    /// The meeting failed to start.
    case meetingStartFailed
    /// The meeting will start.
    case meetingStartRequested
    /// The meeting started.
    case meetingStartSucceeded
    /// The meeting ended.
    case meetingEnded
    /// The meeting failed.
    case meetingFailed
    /// The meeting reconnected.
    case meetingReconnected
    /// unknown
    case unknown

    public var description: String {
        switch self {
        case .audioInputSelected:
            return "audioInputSelected"
        case .videoInputSelected:
            return "videoInputSelected"
        case .videoInputFailed:
            return "videoInputFailed"
        case .meetingStartFailed:
            return "meetingStartFailed"
        case .meetingStartRequested:
            return "meetingStartRequested"
        case .meetingStartSucceeded:
            return "meetingStartSucceeded"
        case .meetingEnded:
            return "meetingEnded"
        case .meetingFailed:
            return "meetingFailed"
        case .meetingReconnected:
            return "meetingReconnected"
        case .unknown:
            return "unknown"
        }
    }
}
