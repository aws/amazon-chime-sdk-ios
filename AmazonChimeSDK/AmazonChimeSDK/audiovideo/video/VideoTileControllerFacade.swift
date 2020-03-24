//
//  VideoTileControllerFacade.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `VideoTileControllerFacade` allows one to control `VideoTile`. The caller is responsible for laying
/// out video render views as desired and binding tile ids received from the observer
/// in the `videoTileDidAdd` and `videoTileDidRemove` callbacks.
@objc public protocol VideoTileControllerFacade {
    /// Binds the video rendering view to Video Tile. The view will start displaying the video frame
    /// after the completion of this API
    ///
    /// - Parameters:
    ///   - videoView: View to render the video. Application needs to create it and pass to SDK.
    ///   - tileId: id of the tile which was passed to the application in `VideoTileObserver.videoTileDidAdd`
    func bindVideoView(videoView: VideoRenderView, tileId: Int)

    /// Unbinds the video rendering view from Video Tile. The view will stop displaying the video frame
    /// after the completion of this API
    ///
    /// - Parameter tileId: id of the tile which was passed to the application in `VideoTileObserver.videoTileDidRemove`
    func unbindVideoView(tileId: Int)

    /// Subscribe to Video Tile events with an `VideoTileObserver`.
    ///
    /// - Parameter observer: The observer to subscribe to events with
    func addVideoTileObserver(observer: VideoTileObserver)

    /// Unsubscribes from Video Tile events by removing specified `VideoTileObserver`.
    ///
    /// - Parameter observer: The observer to unsubscribe from events with
    func removeVideoTileObserver(observer: VideoTileObserver)

    /// Pauses remote video tile, if it exists.
    ///
    /// - Parameter tileId: The tile id to pause
    func pauseRemoteVideoTile(tileId: Int)

    /// Resume remote video tile, if it exists.
    ///
    /// - Parameter tileId: The tile id to resume
    func resumeRemoteVideoTile(tileId: Int)
}
