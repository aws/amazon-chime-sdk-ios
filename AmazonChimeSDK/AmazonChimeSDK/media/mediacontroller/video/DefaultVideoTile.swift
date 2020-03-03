//
//  DefaultVideoTile.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

@objcMembers public class DefaultVideoTile: VideoTile {
    public var state: VideoTileState

    private let logger: Logger

    public var videoRenderView: VideoRenderView?

    init(logger: Logger, tileId: Int, attendeeId: String?) {
        self.logger = logger
        self.state = VideoTileState(tileId: tileId, attendeeId: attendeeId, paused: false)
    }

    // TODO: figure out what todo with this bind if builder decide to call this directly
    public func bind(videoRenderView: VideoRenderView?) {
        logger.info(msg: "Binding the view to tile: tileId: \(state.tileId), attendeeId: \(state.attendeeId ?? "self")")
        self.videoRenderView = videoRenderView
    }

    public func renderFrame(frame: Any?) {
        videoRenderView?.renderFrame(frame: frame)
    }

    public func unbind() {
        logger.info(msg: "Unbinding the view from tile: tileId:  \(state.tileId), attendeeId: \(state.attendeeId ?? "self")")
        videoRenderView = nil
    }

    public func pause() {
        state.paused = true
    }

    public func resume() {
        state.paused = false
    }
}
