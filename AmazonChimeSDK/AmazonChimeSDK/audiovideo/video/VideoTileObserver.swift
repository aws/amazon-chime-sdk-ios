//
//  VideoTileObserver.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `VideoTileObserver` handles events related to `VideoTile`.
@objc public protocol VideoTileObserver {
    /// Called whenever a new attendee starts sharing the video
    /// - Parameters:
    ///   - tileState: video tile state associated with this attendee
    func videoTileDidAdd(tileState: VideoTileState)

    /// Called whenever any attendee stops sharing the video
    /// - Parameters:
    ///   - tileState: video tile state associated with this attendee
    func videoTileDidRemove(tileState: VideoTileState)

    /// Called whenever an attendee tile pauseState changes from .unpaused
    /// - Parameters:
    ///   - tileState: video tile state associated with this attendee
    func videoTileDidPause(tileState: VideoTileState)

    /// Called whenever an attendee tile pauseState changes to .unpaused
    /// - Parameters:
    ///   - tileState: video tile state associated with this attendee
    func videoTileDidResume(tileState: VideoTileState)
}
