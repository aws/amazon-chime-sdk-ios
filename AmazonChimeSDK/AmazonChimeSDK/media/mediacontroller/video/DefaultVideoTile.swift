//
//  DefaultVideoTile.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

public class DefaultVideoTile: VideoTile {
    private let logger: Logger

    public let tileId: Int
    public let attendeeId: String?
    public var videoRenderView: VideoRenderView?
    public var paused: Bool

    init(logger: Logger, tileId: Int, attendeeId: String?) {
        self.tileId = tileId
        self.attendeeId = attendeeId
        self.logger = logger
        self.paused = false
    }

    public func bind(videoRenderView: VideoRenderView?) {
        logger.info(msg: "Binding the view to tile: tileId: \(tileId), attendeeId: \(attendeeId ?? "self")")
        self.videoRenderView = videoRenderView
    }

    public func renderFrame(frame: Any?) {
        videoRenderView?.renderFrame(frame: frame)
    }

    public func unbind() {
        logger.info(msg: "Unbinding the view from tile: tileId:  \(tileId), attendeeId: \(attendeeId ?? "self")")
        videoRenderView = nil
    }

    public func pause() {
        self.paused = true
    }

    public func unpause() {
        self.paused = false
    }
}
