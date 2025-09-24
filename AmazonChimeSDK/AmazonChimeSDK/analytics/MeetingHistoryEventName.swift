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
    /// The microphone selection or access failed.
    case audioInputFailed
    /// The camera was selected.
    case videoInputSelected
    /// The camera selection or access failed.
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
    /// The video client signaling websocket failed or closed with an error.
    case videoClientSignalingDropped
    /// The content share signaling websocket failed or closed with an error.
    case contentShareSignalingDropped
    /// Content share start was requested.
    case contentShareStartRequested
    /// Content share started successfully.
    case contentShareStarted
    /// Content share stopped.
    case contentShareStopped
    /// Content share failed.
    case contentShareFailed
    /// The application state is changed
    case appStateChanged
    /// The application memory is low
    case appMemoryLow
    /// unknown
    case unknown

    public var description: String {
        switch self {
        case .audioInputSelected:
            return "audioInputSelected"
        case .audioInputFailed:
            return "audioInputFailed"
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
        case .videoClientSignalingDropped:
            return "videoClientSignalingDropped"
        case .contentShareSignalingDropped:
            return "contentShareSignalingDropped"
        case .contentShareStartRequested:
            return "contentShareStartRequested"
        case .contentShareStarted:
            return "contentShareStarted"
        case .contentShareStopped:
            return "contentShareStopped"
        case .contentShareFailed:
            return "contentShareFailed"
        case .appStateChanged:
            return "appStateChanged"
        case .appMemoryLow:
            return "appMemoryLow"
        case .unknown:
            return "unknown"
        }
    }
}
