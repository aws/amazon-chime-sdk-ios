//
//  DefaultVideoTileController.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import UIKit

@objcMembers public class DefaultVideoTileController: NSObject, VideoTileController {
    private let logger: Logger
    private var videoTileMap = [Int: VideoTile]()
    private var videoViewToTileMap = [NSValue: VideoTile]()
    private let videoTileObservers = ConcurrentMutableSet()
    private let videoClientController: VideoClientController
    private let meetingStatsCollector: MeetingStatsCollector

    public init(videoClientController: VideoClientController,
                logger: Logger,
                meetingStatsCollector: MeetingStatsCollector) {
        self.videoClientController = videoClientController
        self.logger = logger
        self.meetingStatsCollector = meetingStatsCollector
    }

    public func onReceiveFrame(frame: VideoFrame?,
                               videoId: Int,
                               attendeeId: String?,
                               pauseState: VideoPauseState) {
        var videoStreamContentWidth = 0
        var videoStreamContentHeight = 0

        if let frame = frame {
            videoStreamContentWidth = frame.width
            videoStreamContentHeight = frame.height
        }

        if let videoTile = videoTileMap[videoId] {
            // when removing video track, video client will send an unpaused nil frame
            if pauseState == .unpaused && frame == nil {
                onRemoveTrack(tileState: videoTile.state)
                return
            }

            if frame != nil && (videoStreamContentWidth != videoTile.state.videoStreamContentWidth ||
                videoStreamContentHeight != videoTile.state.videoStreamContentHeight) {
                videoTile.state.videoStreamContentWidth = videoStreamContentWidth
                videoTile.state.videoStreamContentHeight = videoStreamContentHeight
                ObserverUtils.forEach(observers: videoTileObservers) { (videoTileObserver: VideoTileObserver) in
                    videoTileObserver.videoTileSizeDidChange(tileState: videoTile.state)
                }
            }

            // Account for any internally changed pause states, but ignore if the tile is paused by
            // user since the pause might not have propagated yet
            if pauseState != videoTile.state.pauseState, videoTile.state.pauseState != .pausedByUserRequest {
                // Note that currently, since we preemptively mark tiles as .pausedByUserRequest when requested by user
                // this path will only be hit when we are either transitioning from .unpaused
                // to .pausedForPoorConnection or .pausedForPoorConnection to .unpaused
                videoTile.setPauseState(pauseState: pauseState)
                if pauseState == .unpaused {
                    ObserverUtils.forEach(observers: videoTileObservers) { (videoTileObserver: VideoTileObserver) in
                        videoTileObserver.videoTileDidResume(tileState: videoTile.state)
                    }
                } else {
                    ObserverUtils.forEach(observers: videoTileObservers) { (videoTileObserver: VideoTileObserver) in
                        videoTileObserver.videoTileDidPause(tileState: videoTile.state)
                    }
                }
            }

            // only render unpaused non-nil frames
            if videoTile.state.pauseState == .unpaused, let frame = frame {
                videoTile.onVideoFrameReceived(frame: frame)
            }
        } else if frame != nil || pauseState != .unpaused {
            onAddTrack(tileId: videoId,
                       attendeeId: attendeeId,
                       pauseState: pauseState,
                       videoStreamContentWidth: videoStreamContentWidth,
                       videoStreamContentHeight: videoStreamContentHeight)
        }
    }

    public func bindVideoView(videoView: VideoRenderView, tileId: Int) {
        logger.info(msg: "Binding VideoView to Tile with tileId = \(tileId)")
        let videoRenderKey = NSValue(nonretainedObject: videoView)

        // Previously there was another videoTile that bounded to the videoView, unbind it
        if let matchedTile = videoViewToTileMap[videoRenderKey] {
            logger.info(msg: "Override the binding from \(matchedTile.state.tileId) to \(tileId)")
            removeVideoViewBindMapping(tileId: matchedTile.state.tileId)
        }

        if let videoTile = videoTileMap[tileId] {
            if videoTile.videoRenderView != nil {
                // If tileId was already bound to another videoRenderView, unbind it
                logger.info(msg: "tileId = \(tileId) already had a different video view. Unbinding the old one and associating the new one")
                removeVideoViewBindMapping(tileId: tileId)
            }
            videoTile.bind(videoRenderView: videoView)
            videoViewToTileMap[videoRenderKey] = videoTile
        }
    }

    private func removeVideoViewBindMapping(tileId: Int) {
        videoViewToTileMap.first(where: { $1.state.tileId == tileId }).map { videoRenderKey, videoTile in
            videoTile.unbind()
            videoViewToTileMap.removeValue(forKey: videoRenderKey)
        }
    }

    public func unbindVideoView(tileId: Int) {
        logger.info(msg: "Unbinding VideoView to Tile with tileId = \(tileId)")
        // Remove the video from both mappings when unbind, in order to keep the old SDK behavior
        videoTileMap.removeValue(forKey: tileId)
        removeVideoViewBindMapping(tileId: tileId)
    }

    private func onAddTrack(tileId: Int,
                            attendeeId: String?,
                            pauseState: VideoPauseState,
                            videoStreamContentWidth: Int,
                            videoStreamContentHeight: Int) {
        var isLocalTile: Bool
        var thisAttendeeId: String
        let selfAttendeeId = videoClientController.getConfiguration().credentials.attendeeId

        if let attendeeId = attendeeId {
            thisAttendeeId = attendeeId
            isLocalTile = false
        } else {
            thisAttendeeId = selfAttendeeId
            isLocalTile = true
        }
        let tile = DefaultVideoTile(tileId: tileId,
                                    attendeeId: thisAttendeeId,
                                    videoStreamContentWidth: videoStreamContentWidth,
                                    videoStreamContentHeight: videoStreamContentHeight,
                                    isLocalTile: isLocalTile,
                                    logger: logger)
        tile.setPauseState(pauseState: pauseState)
        videoTileMap[tileId] = tile
        self.meetingStatsCollector.updateMaxVideoTile(videoTileCount: videoTileMap.count)
        ObserverUtils.forEach(observers: videoTileObservers) { (videoTileObserver: VideoTileObserver) in
            videoTileObserver.videoTileDidAdd(tileState: tile.state)
        }
    }

    private func onRemoveTrack(tileState: VideoTileState) {
        ObserverUtils.forEach(observers: videoTileObservers) { (videoTileObserver: VideoTileObserver) in
            videoTileObserver.videoTileDidRemove(tileState: tileState)
        }
        videoTileMap.removeValue(forKey: tileState.tileId)
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
                ObserverUtils.forEach(observers: videoTileObservers) { (videoTileObserver: VideoTileObserver) in
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
                ObserverUtils.forEach(observers: videoTileObservers) { (videoTileObserver: VideoTileObserver) in
                    videoTileObserver.videoTileDidResume(tileState: videoTile.state)
                }
            }
        }
    }
}
