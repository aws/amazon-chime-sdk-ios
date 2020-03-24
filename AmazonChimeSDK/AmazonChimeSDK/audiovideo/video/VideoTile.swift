//
//  VideoTile.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
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

    /// Update the pause state of the tile.
    func setPauseState(pauseState: VideoPauseState)
}
