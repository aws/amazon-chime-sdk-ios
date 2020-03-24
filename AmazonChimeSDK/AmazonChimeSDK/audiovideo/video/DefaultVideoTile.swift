//
//  DefaultVideoTile.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers public class DefaultVideoTile: VideoTile {
    public var state: VideoTileState

    private let logger: Logger

    public var videoRenderView: VideoRenderView?

    init(logger: Logger, tileId: Int, attendeeId: String?) {
        self.logger = logger
        self.state = VideoTileState(tileId: tileId, attendeeId: attendeeId, pauseState: .unpaused)
    }

    public func bind(videoRenderView: VideoRenderView?) {
        logger.info(
            msg: "Binding the view to tile: tileId: \(state.tileId), attendeeId: \(state.attendeeId ?? "self")"
        )
        self.videoRenderView = videoRenderView
    }

    public func renderFrame(frame: Any?) {
        videoRenderView?.renderFrame(frame: frame)
    }

    public func unbind() {
        logger.info(
            msg: "Unbinding the view from tile: tileId:  \(state.tileId), attendeeId: \(state.attendeeId ?? "self")"
        )
        videoRenderView = nil
    }

    public func setPauseState(pauseState: VideoPauseState) {
        state.pauseState = pauseState
    }
}
