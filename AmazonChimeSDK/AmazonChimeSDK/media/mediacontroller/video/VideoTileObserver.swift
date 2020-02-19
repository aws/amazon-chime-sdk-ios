//
//  VideoTileObserver.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

public protocol VideoTileObserver {
    /// Called whenever a new attendee starts sharing the video
    /// - Parameters:
    ///   - tile: video tile associated with this attendee
    func onAddVideoTrack(tile: VideoTile)

    /// Called whenever any attendee stops sharing the video
    /// - Parameters:
    ///   - tile: video tile associated with this attendee
    func onRemoveVideoTrack(tile: VideoTile)
}
