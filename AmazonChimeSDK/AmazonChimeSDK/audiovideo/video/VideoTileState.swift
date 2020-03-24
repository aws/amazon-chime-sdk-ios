//
//  VideoTileState.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

/// `VideoTileState` encapsulates the state of a `VideoTile`.
@objcMembers public class VideoTileState: NSObject {
    /// Unique Id associated with this tile
    public let tileId: Int

    /// Whether tile is local or remote tile
    public let isLocalTile: Bool

    /// Id of the user associated with this tile
    public let attendeeId: String?

    /// Whether this is screen share
    public let isContent: Bool

    /// Current pause state of this tile
    public var pauseState: VideoPauseState

    init(tileId: Int, attendeeId: String?, pauseState: VideoPauseState) {
        self.tileId = tileId
        self.attendeeId = attendeeId
        self.pauseState = pauseState
        self.isLocalTile = attendeeId == nil
        self.isContent = attendeeId?.hasSuffix(Constants.modality) ?? false
    }
}
