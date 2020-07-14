//
//  VideoModel.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import UIKit

class VideoModel: NSObject {
    private let maxRemoteVideoTileCount = 8

    private var selfVideoTileState: VideoTileState?
    private var remoteVideoTileStates: [(Int, VideoTileState)] = []
    private let audioVideoFacade: AudioVideoFacade

    var videoUpdatedHandler: (() -> Void)?
    var localVideoUpdatedHandler: (() -> Void)?

    init(audioVideoFacade: AudioVideoFacade) {
        self.audioVideoFacade = audioVideoFacade
        super.init()
    }

    var videoTileCount: Int {
        return currentRemoteVideoCount + 1
    }

    private var currentRemoteVideoCount: Int {
        return remoteVideoTileStates.count
    }

    private var isMaximumRemoteVideoReached: Bool {
        return currentRemoteVideoCount >= maxRemoteVideoTileCount
    }

    func setSelfVideoTileState(_ videoTileState: VideoTileState?) {
        selfVideoTileState = videoTileState
    }

    func addRemoteVideoTileState(_ videoTileState: VideoTileState, completion: @escaping (Bool) -> Void) {
        if isMaximumRemoteVideoReached {
            completion(false)
            return
        }
        remoteVideoTileStates.append((videoTileState.tileId, videoTileState))
        completion(true)
    }

    func removeRemoteVideoTileState(_ videoTileState: VideoTileState, completion: @escaping (Bool) -> Void) {
        if let index = remoteVideoTileStates.firstIndex(where: { $0.0 == videoTileState.tileId }) {
            remoteVideoTileStates.remove(at: index)
            completion(true)
        } else {
            completion(false)
        }
    }

    func resumeAllRemoteVideo() {
        for remoteVideoTileState in remoteVideoTileStates {
            audioVideoFacade.resumeRemoteVideoTile(tileId: remoteVideoTileState.0)
        }
    }

    func pauseAllRemoteVideo() {
        for remoteVideoTileState in remoteVideoTileStates {
            audioVideoFacade.pauseRemoteVideoTile(tileId: remoteVideoTileState.0)
        }
    }

    func getVideoTileState(for indexPath: IndexPath) -> VideoTileState? {
        if indexPath.item == 0 {
            return selfVideoTileState
        }
        if indexPath.item > currentRemoteVideoCount {
            return nil
        }
        return remoteVideoTileStates[indexPath.item - 1].1
    }
}

extension VideoModel: VideoTileCellDelegate {
    func onTileButtonClicked(tag: Int, selected: Bool) {
        if tag == 0 {
            audioVideoFacade.switchCamera()
        } else {
            if let tileState = getVideoTileState(for: IndexPath(item: tag, section: 0)), !tileState.isLocalTile {
                if selected {
                    audioVideoFacade.pauseRemoteVideoTile(tileId: tileState.tileId)
                } else {
                    audioVideoFacade.resumeRemoteVideoTile(tileId: tileState.tileId)
                }
            }
        }
    }
}
