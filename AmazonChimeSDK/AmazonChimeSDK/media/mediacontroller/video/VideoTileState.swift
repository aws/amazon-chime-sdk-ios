//
//  VideoTileState.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

@objcMembers public class VideoTileState: NSObject {
    /// Unique Id associated with this tile
    public let tileId: Int

    /// Whether tile is local or remote tile
    public let isLocalTile: Bool

    /// Id of the user associated with this tile
    public let attendeeId: String?

    // Whether this is screen share
    public let isContent: Bool

    /// If this tile is paused
    public var paused: Bool

    init(tileId: Int, attendeeId: String?, paused: Bool) {
        self.tileId = tileId
        self.attendeeId = attendeeId
        self.paused = paused
        self.isLocalTile = attendeeId == nil
        self.isContent = attendeeId?.hasSuffix(Constants.modality) ?? false
    }
}
