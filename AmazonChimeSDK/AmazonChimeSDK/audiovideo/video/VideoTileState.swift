//
//  VideoTileState.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `VideoTileState` encapsulates the state of a `VideoTile`.
@objcMembers public class VideoTileState: NSObject {
    /// Unique Id associated with this tile
    public let tileId: Int

    /// Id of the user associated with this tile
    public let attendeeId: String

    /// Width of video stream content
    public var videoStreamContentWidth: Int

    /// Height of video stream content
    public var videoStreamContentHeight: Int

    /// Current pause state of this tile
    public var pauseState: VideoPauseState

    /// Whether tile is local or remote tile
    public let isLocalTile: Bool

    /// Whether this is screen share
    public let isContent: Bool

    public init(tileId: Int,
                attendeeId: String,
                videoStreamContentWidth: Int,
                videoStreamContentHeight: Int,
                pauseState: VideoPauseState,
                isLocalTile: Bool) {
        self.tileId = tileId
        self.attendeeId = attendeeId
        self.videoStreamContentWidth = videoStreamContentWidth
        self.videoStreamContentHeight = videoStreamContentHeight
        self.pauseState = pauseState
        self.isLocalTile = isLocalTile
        self.isContent = attendeeId.hasSuffix(Constants.modality)
    }
}
