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
    /// The microphone was selected.
    case audioInputSelected
    /// The microphone selection or access failed
    case audioInputFailed
    /// The camera was selected.
    case videoInputSelected
    /// The camera selection or access failed
    case videoInputFailed
    /// The meeting will start
    case meetingStartRequested
    /// The meeting started
    case meetingStartSucceeded
    /// The meeting reconnected
    case meetingReconnected
    /// The meeting failed to start
    case meetingStartFailed
    /// The meeting ended with failure
    case meetingFailed
    /// The meeting ended
    case meetingEnded
    /// The video client signaling websocket opened
    case videoClientSignalingOpened
    /// The video client signaling websocket failed or closed with an error
    case videoClientSignalingDropped
    /// The content share signaling websocket opened
    case contentShareSignalingOpened
    /// The content share signaling websocket failed or closed with an error
    case contentShareSignalingDropped
    /// The video client ICE candidate gathering has finished
    case videoClientIceGatheringCompleted
    /// The content share ICE candidate gathering has finished
    case contentShareIceGatheringCompleted
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
    /// Voice focus enabled
    case voiceFocusEnabled
    /// Voice focus disabled
    case voiceFocusDisabled
    /// Failed to enable voice focus
    case voiceFocusEnableFailed
    /// Failed to disable voice focus
    case voiceFocusDisableFailed
    /// Audio interruption began
    case audioInterruptionBegan
    /// Audio interruption ended
    case audioInterruptionEnded
    /// Video interruption began
    case videoInterruptionBegan
    /// Video interruption ended
    case videoInterruptionEnded
    /// Network connection type is changed
    case networkConnectionTypeChanged
    // unknown
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
        case .meetingStartRequested:
            return "meetingStartRequested"
        case .meetingStartSucceeded:
            return "meetingStartSucceeded"
        case .meetingReconnected:
            return "meetingReconnected"
        case .meetingStartFailed:
            return "meetingStartFailed"
        case .meetingFailed:
            return "meetingFailed"
        case .meetingEnded:
            return "meetingEnded"
        case .videoClientSignalingOpened:
            return "videoClientSignalingOpened"
        case .videoClientSignalingDropped:
            return "videoClientSignalingDropped"
        case .contentShareSignalingOpened:
            return "contentShareSignalingOpened"
        case .contentShareSignalingDropped:
            return "contentShareSignalingDropped"
        case .videoClientIceGatheringCompleted:
            return "videoClientIceGatheringCompleted"
        case .contentShareIceGatheringCompleted:
            return "contentShareIceGatheringCompleted"
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
        case .voiceFocusEnabled:
            return "voiceFocusEnabled"
        case .voiceFocusDisabled:
            return "voiceFocusDisabled"
        case .voiceFocusEnableFailed:
            return "voiceFocusEnableFailed"
        case .voiceFocusDisableFailed:
            return "voiceFocusDisableFailed"
        case .audioInterruptionBegan:
            return "audioInterruptionBegan"
        case .audioInterruptionEnded:
            return "audioInterruptionEnded"
        case .videoInterruptionBegan:
            return "videoInterruptionBegan"
        case .videoInterruptionEnded:
            return "videoInterruptionEnded"
        case .networkConnectionTypeChanged:
            return "networkConnectionTypeChanged"
        case .unknown:
            return "unknown"
        }
    }

    static func toEventName(name: String) -> EventName {
        switch name {
        case "audioInputSelected":
            return .audioInputSelected
        case "audioInputFailed":
            return .audioInputFailed
        case "videoInputSelected":
            return .videoInputSelected
        case "videoInputFailed":
            return .videoInputFailed
        case "meetingStartRequested":
            return .meetingStartRequested
        case "meetingStartSucceeded":
            return .meetingStartSucceeded
        case "meetingReconnected":
            return .meetingReconnected
        case "meetingStartFailed":
            return .meetingStartFailed
        case "meetingFailed":
            return .meetingFailed
        case "meetingEnded":
            return .meetingEnded
        case "videoClientSignalingOpened":
            return .videoClientSignalingOpened
        case "videoClientSignalingDropped":
            return .videoClientSignalingDropped
        case "contentShareSignalingOpened":
            return .contentShareSignalingOpened
        case "contentShareSignalingDropped":
            return .contentShareSignalingDropped
        case "videoClientIceGatheringCompleted":
            return .videoClientIceGatheringCompleted
        case "contentShareIceGatheringCompleted":
            return .contentShareIceGatheringCompleted
        case "contentShareStartRequested":
            return .contentShareStartRequested
        case "contentShareStarted":
            return .contentShareStarted
        case "contentShareStopped":
            return .contentShareStopped
        case "contentShareFailed":
            return .contentShareFailed
        case "appStateChanged":
            return .appStateChanged
        case "appMemoryLow":
            return .appMemoryLow
        case "voiceFocusEnabled":
            return .voiceFocusEnabled
        case "voiceFocusDisabled":
            return .voiceFocusDisabled
        case "voiceFocusEnableFailed":
            return .voiceFocusEnableFailed
        case "voiceFocusDisableFailed":
            return .voiceFocusDisableFailed
        case "audioInterruptionBegan":
            return .audioInterruptionBegan
        case "audioInterruptionEnded":
            return .audioInterruptionEnded
        case "videoInterruptionBegan":
            return .videoInterruptionBegan
        case "videoInterruptionEnded":
            return .videoInterruptionEnded
        case "networkConnectionTypeChanged":
            return .networkConnectionTypeChanged
        default:
            return .unknown
        }
    }
}
