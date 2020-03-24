//
//  VideoPauseState.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `VideoPauseState` describes the pause status of a video tile.
@objc public enum VideoPauseState: Int, CaseIterable, CustomStringConvertible {
    /// The video tile is not paused
    case unpaused = 0

    /// The video tile has been paused by the user, and will only be unpaused if the user requests it to resume.
    case pausedByUserRequest = 1

    /// The video tile has been paused to save on local downlink bandwidth.  When the connection improves,
    /// it will be automatically unpaused by the client.  User requested pauses will shadow this pause,
    /// but if the connection has not recovered on resume the tile will still be paused with this state.
    case pausedForPoorConnection = 2

    public var description: String {
        switch self {
        case .unpaused:
            return "unpaused"
        case .pausedByUserRequest:
            return "pausedByUserRequest"
        case .pausedForPoorConnection:
            return "pausedForPoorConnection"
        }
    }
}
