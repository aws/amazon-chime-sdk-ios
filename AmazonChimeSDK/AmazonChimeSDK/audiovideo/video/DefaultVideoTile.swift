//
//  DefaultVideoTile.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import VideoToolbox

@objcMembers public class DefaultVideoTile: NSObject, VideoTile {
    public var state: VideoTileState

    private let logger: Logger

    public var videoRenderView: VideoRenderView?

    public init(tileId: Int,
                attendeeId: String,
                videoStreamContentWidth: Int,
                videoStreamContentHeight: Int,
                isLocalTile: Bool,
                logger: Logger) {
        state = VideoTileState(tileId: tileId,
                               attendeeId: attendeeId,
                               videoStreamContentWidth: videoStreamContentWidth,
                               videoStreamContentHeight: videoStreamContentHeight,
                               pauseState: .unpaused,
                               isLocalTile: isLocalTile)
        self.logger = logger
    }

    public func bind(videoRenderView: VideoRenderView?) {
        logger.info(
            msg: "Binding the view to tile: tileId: \(state.tileId), attendeeId: \(state.attendeeId)"
        )
        self.videoRenderView = videoRenderView
    }

    public func renderFrame(frame: CVPixelBuffer?) {
        videoRenderView?.renderFrame(frame: frame)
    }

    public func unbind() {
        logger.info(
            msg: "Unbinding the view from tile: tileId: \(state.tileId), attendeeId: \(state.attendeeId)"
        )
        videoRenderView = nil
    }

    public func setPauseState(pauseState: VideoPauseState) {
        state.pauseState = pauseState
    }
}
