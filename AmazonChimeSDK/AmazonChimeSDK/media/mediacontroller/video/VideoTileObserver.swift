//
//  VideoTileObserver.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

/// `VideoTileObserver` handles events related to `VideoTile`.
@objc public protocol VideoTileObserver {
    /// Called whenever a new attendee starts sharing the video
    /// - Parameters:
    ///   - tileState: video tile state associated with this attendee
    func onAddVideoTile(tileState: VideoTileState)

    /// Called whenever any attendee stops sharing the video
    /// - Parameters:
    ///   - tileState: video tile state associated with this attendee
    func onRemoveVideoTile(tileState: VideoTileState)
}
