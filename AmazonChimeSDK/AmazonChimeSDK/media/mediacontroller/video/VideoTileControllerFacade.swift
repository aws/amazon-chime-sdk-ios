//
//  VideoTileControllerFacade.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

public protocol VideoTileControllerFacade {
    /// Binds the video rendering view to Video Tile. The view will start displaying the video frame
    /// after the completion of this API
    ///
    /// - Parameters:
    ///   - videoView: View to render the video. Application needs to create it and pass to SDK.
    ///   - tileId: id of the tile which was passed to the application in `VideoTileObserver.onAddVideoTrack`
    func bindVideoView(videoView: VideoRenderView, tileId: Int)

    /// Unbinds the video rendering view from Video Tile. The view will stop displaying the video frame
    /// after the completion of this API
    ///
    /// - Parameter tileId: id of the tile which was passed to the application in `VideoTileObserver.onRemoveVideoTrack`
    func unbindVideoView(tileId: Int)

    /// Subscribe to Video Tile events with an `VideoTileObserver`.
    ///
    /// - Parameter observer: The observer to subscribe to events with
    func addVideoTileObserver(observer: VideoTileObserver)

    /// Unsubscribes from Video Tile events by removing specified `VideoTileObserver`.
    ///
    /// - Parameter observer: The observer to unsubscribe from events with
    func removeVideoTileObserver(observer: VideoTileObserver)
}
