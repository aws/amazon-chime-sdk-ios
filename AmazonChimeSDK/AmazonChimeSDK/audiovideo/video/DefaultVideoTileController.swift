//
//  DefaultVideoTileController.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
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

    public func onReceiveFrame(frame: Any?, attendeeId: String?, pauseState: VideoPauseState, videoId: Int) {
        if let videoTile = videoTileMap[videoId] {
            // Account for any internally changed pause states, but ignore if the tile is paused by
            // user since the pause might not have propagated yet
            if pauseState != videoTile.state.pauseState && videoTile.state.pauseState != .pausedByUserRequest {
                // Note that currently, since we preemptively mark tiles as .pausedByUserRequest when requested by user
                // this path will only be hit when we are either transitioning from .unpaused
                // to .pausedForPoorConnection or .pausedForPoorConnection to .unpaused
                videoTile.setPauseState(pauseState: pauseState)
                if pauseState == .unpaused {
                    forEachObserver { videoTileObserver in
                        videoTileObserver.videoTileDidResume(tileState: videoTile.state)
                    }
                } else {
                    forEachObserver { videoTileObserver in
                        videoTileObserver.videoTileDidPause(tileState: videoTile.state)
                    }
                }
            }

            // Ignore any frames which come to an already paused tile
            if videoTile.state.pauseState == .unpaused {
                if frame != nil {
                    videoTile.renderFrame(frame: frame)
                } else {
                    // Nil frames in unpaused state indicate to remove the tile
                    videoTile.renderFrame(frame: nil)
                    onRemoveTrack(tileState: videoTile.state)
                }
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
            videoTileObserver.videoTileDidAdd(tileState: tile.state)
        }
    }

    private func onRemoveTrack(tileState: VideoTileState) {
        forEachObserver { videoTileObserver in
            videoTileObserver.videoTileDidRemove(tileState: tileState)
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
            // Don't update state/observers if we haven't changed anything
            // Note that this will overwrite .pausedForPoorConnection if that is the current state
            if videoTile.state.pauseState != .pausedByUserRequest {
                videoTile.setPauseState(pauseState: .pausedByUserRequest)
                forEachObserver { videoTileObserver in
                    videoTileObserver.videoTileDidPause(tileState: videoTile.state)
                }
            }
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
            // Only update state if we are unpausing a tile which was previously paused by the user
            // Note that this means resuming a tile with state .pausedForPoorConnection will no-op
            if videoTile.state.pauseState == .pausedByUserRequest {
                videoTile.setPauseState(pauseState: .unpaused)
                forEachObserver { videoTileObserver in
                    videoTileObserver.videoTileDidResume(tileState: videoTile.state)
                }
            }
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
