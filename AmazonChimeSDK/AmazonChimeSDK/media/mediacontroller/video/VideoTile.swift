//
//  VideoTile.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

/// `VideoTile` is a tile that binds video render view to diplay the frame into the view.
@objc public protocol VideoTile {
    /// State of VideoTile
    var state: VideoTileState { get }

    /// View which will be used to render the Video Frame
    var videoRenderView: VideoRenderView? { get set }

    /// Binds the view to the tile. The view needs to be create by the application.
    /// Once the binding is done, the view will start displaying the video frame automatically
    ///
    /// - Parameter videoRenderView: the view created by application to render the video frame
    func bind(videoRenderView: VideoRenderView?)

    /// Renders the frame on `videoRenderView`. The call will be silently ignored if the view has not been bind
    /// to the tile using `bind`
    ///
    /// - Parameter frame: a frame of video
    func renderFrame(frame: Any?)

    /// Unbinds the `videoRenderView` from tile.
    func unbind()

    /// Pauses the tile. When paused, the tile moves to an inactive state and will not receive
    /// frame update callback
    func pause()

    /// Resume the tile if it was paused. When resumed,
    /// the tile moves to the active state.
    func resume()
}
