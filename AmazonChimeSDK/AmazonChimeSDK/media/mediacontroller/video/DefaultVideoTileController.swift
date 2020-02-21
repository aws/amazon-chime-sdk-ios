//
//  DefaultVideoTileController.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation
import UIKit

public class DefaultVideoTileController: VideoTileController {
    private let logger: Logger
    private var videoTileMap = [Int: VideoTile]()
    private let videoTileObservers = NSMutableSet()
    private let videoClientController: VideoClientController

    init(logger: Logger, videoClientController: VideoClientController) {
        self.logger = logger
        self.videoClientController = videoClientController
    }

    public func onReceiveFrame(frame: CGImage?, profileId: String?, displayId: Int, pauseType: Int, videoId: Int) {
        if let videoTile = videoTileMap[videoId] {
            if frame != nil {
                videoTile.renderFrame(frame: UIImage(cgImage: frame!))
            } else {
                videoTile.renderFrame(frame: nil)
                DispatchQueue.global(qos: .background).async {
                    self.onRemoveTrack(tile: videoTile)
                }
            }
        } else if frame != nil {
            onAddTrack(videoId: videoId, profileId: profileId)
        }
    }

    public func bindVideoView(videoView: VideoRenderView, tileId: Int) {
        logger.info(msg: "Binding VideoView to Tile with tileId = \(tileId)")
        let videoTile = videoTileMap[tileId]
        videoTile?.bind(videoRenderView: videoView)
    }

    public func unbindVideoView(tileId: Int) {
        logger.info(msg: "Unbinding VideoView to Tile with tileId = \(tileId)")
        let videoTile = videoTileMap.removeValue(forKey: tileId)
        videoTile?.unbind()
    }

    private func onAddTrack(videoId: Int, profileId: String?) {
        let tile = DefaultVideoTile(logger: logger,
                                    tileId: videoId,
                                    attendeeId: profileId)
        videoTileMap[videoId] = tile
        forEachObserver { videoTileObserver in
            videoTileObserver.onAddVideoTrack(tile: tile)
        }
    }

    private func onRemoveTrack(tile: VideoTile) {
        forEachObserver { videoTileObserver in
            videoTileObserver.onRemoveVideoTrack(tile: tile)
        }
    }

    public func addVideoTileObserver(observer: VideoTileObserver) {
        videoTileObservers.add(observer)
    }

    public func removeVideoTileObserver(observer: VideoTileObserver) {
        videoTileObservers.remove(observer)
    }

    public func pauseVideoTile(tileId: Int) {
        if let videoTile = videoTileMap[tileId] {
            logger.info(msg: "pauseVideoTile id=\(tileId)")
            self.videoClientController.pauseResumeRemoteVideo(UInt32(tileId), pause: true)
            videoTile.pause()
        }
    }

    public func unpauseVideoTile(tileId: Int) {
        if let videoTile = videoTileMap[tileId] {
            logger.info(msg: "unpauseVideoTile id=\(tileId)")
            self.videoClientController.pauseResumeRemoteVideo(UInt32(tileId), pause: false)
            videoTile.unpause()
        }
    }

    private func forEachObserver(observerFunction: (_ observer: VideoTileObserver) -> Void) {
        for observer in videoTileObservers {
            if let observer = observer as? VideoTileObserver {
                observerFunction(observer)
            }
        }
    }
}
