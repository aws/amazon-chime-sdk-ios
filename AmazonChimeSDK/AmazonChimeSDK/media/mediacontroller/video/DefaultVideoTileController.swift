//
//  DefaultVideoTileController.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation
import UIKit

@objcMembers public class DefaultVideoTileController: VideoTileController {
    private let logger: Logger
    private var videoTileMap = [Int: VideoTile]()
    private var videoViewToTileMap = [NSValue: Int]()
    private let videoTileObservers = NSMutableSet()
    private let videoClientController: VideoClientController

    init(logger: Logger, videoClientController: VideoClientController) {
        self.logger = logger
        self.videoClientController = videoClientController
    }

    public func onReceiveFrame(frame: Any?, attendeeId: String?, videoId: Int) {
        if let videoTile = videoTileMap[videoId] {
            if frame != nil {
                videoTile.renderFrame(frame: frame)
            } else {
                videoTile.renderFrame(frame: nil)
                onRemoveTrack(tileState: videoTile.state)
            }
        } else if frame != nil {
            onAddTrack(videoId: videoId, attendeeId: attendeeId)
        }
    }

    public func bindVideoView(videoView: VideoRenderView, tileId: Int) {
        logger.info(msg: "Binding VideoView to Tile with tileId = \(tileId)")
        let videoRenderKey = NSValue(nonretainedObject: videoView)

        // Previously there was another video tile that registered with different tileId
        if let matchedTileId = videoViewToTileMap[videoRenderKey] {
            unbindVideoView(tileId: matchedTileId, removeTile: false)
        }

        let videoTile = videoTileMap[tileId]
        videoTile?.bind(videoRenderView: videoView)
        videoViewToTileMap[videoRenderKey] = tileId
    }

    private func unbindVideoView(tileId: Int, removeTile: Bool) {
        let videoTile = removeTile ? videoTileMap.removeValue(forKey: tileId) : videoTileMap[tileId]
        let videoRenderKey = NSValue(nonretainedObject: videoTile?.videoRenderView)
        videoViewToTileMap.removeValue(forKey: videoRenderKey)
        videoTile?.unbind()
    }

    public func unbindVideoView(tileId: Int) {
        logger.info(msg: "Unbinding VideoView to Tile with tileId = \(tileId)")
        unbindVideoView(tileId: tileId, removeTile: true)
    }

    private func onAddTrack(videoId: Int, attendeeId: String?) {
        let tile = DefaultVideoTile(logger: logger,
                                    tileId: videoId,
                                    attendeeId: attendeeId)
        videoTileMap[videoId] = tile
        forEachObserver { videoTileObserver in
            videoTileObserver.onAddVideoTile(tileState: tile.state)
        }
    }

    private func onRemoveTrack(tileState: VideoTileState) {
        forEachObserver { videoTileObserver in
            videoTileObserver.onRemoveVideoTile(tileState: tileState)
        }
    }

    public func addVideoTileObserver(observer: VideoTileObserver) {
        videoTileObservers.add(observer)
    }

    public func removeVideoTileObserver(observer: VideoTileObserver) {
        videoTileObservers.remove(observer)
    }

    public func pauseRemoteVideoTile(tileId: Int) {
        if let videoTile = videoTileMap[tileId] {
            if videoTile.state.isLocalTile {
                logger.fault(msg: "You cannot pauseRemoteVideoTile on local VideoTile")
                return
            }

            logger.info(msg: "pauseRemoteVideoTile id=\(tileId)")
            videoClientController.pauseResumeRemoteVideo(UInt32(tileId), pause: true)
            videoTile.pause()
        }
    }

    public func resumeRemoteVideoTile(tileId: Int) {
        if let videoTile = videoTileMap[tileId] {
            if videoTile.state.isLocalTile {
                logger.fault(msg: "You cannot resumeRemoteVideoTile on local VideoTile")
                return
            }

            logger.info(msg: "resumeRemoteVideoTile id=\(tileId)")
            videoClientController.pauseResumeRemoteVideo(UInt32(tileId), pause: false)
            videoTile.resume()
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
