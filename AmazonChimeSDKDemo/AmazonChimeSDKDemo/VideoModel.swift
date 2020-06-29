//
//  VideoModel.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import UIKit

protocol VideoModelDelegate: class {
    func isFrontCameraActive() -> Bool
    func getVideoTileDisplayName(for videoTile: VideoTileState) -> String
    func bindVideoView(videoView: VideoRenderView, tileId: Int)
    func switchCamera()
    func pauseVideo(tileId: Int)
    func resumeVideo(tileId: Int)
}

class VideoModel: NSObject {
    private let maxRemoteVideoTileCount = 8

    private var selfVideoTileState: VideoTileState?
    private var remoteVideoTileStates: [(Int, VideoTileState)] = []

    weak var delegate: VideoModelDelegate?

    var currentRemoteVideoCount: Int {
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
            delegate?.resumeVideo(tileId: remoteVideoTileState.0)
        }
    }

    func pauseAllRemoteVideo() {
        for remoteVideoTileState in remoteVideoTileStates {
            delegate?.pauseVideo(tileId: remoteVideoTileState.0)
        }
    }

    private func getVideoTileState(for indexPath: IndexPath) -> VideoTileState? {
        if indexPath.item == 0 {
            return selfVideoTileState
        }
        if indexPath.item > currentRemoteVideoCount {
            return nil
        }
        return remoteVideoTileStates[indexPath.item - 1].1
    }

    private func getVideoTileDisplayName(for indexPath: IndexPath) -> String {
        var displayName = ""
        if indexPath.item == 0, selfVideoTileState == nil {
            displayName = "Turn on your video"
        } else {
            let videoTileState = getVideoTileState(for: indexPath)
            if let videoTileState = videoTileState {
                displayName = delegate?.getVideoTileDisplayName(for: videoTileState) ?? ""
            }
        }
        return displayName
    }
}

// MARK: UICollectionViewDataSource

extension VideoModel: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        // Only one section for all video tiles
        return 1
    }

    func collectionView(_: UICollectionView,
                        numberOfItemsInSection _: Int) -> Int {
        return currentRemoteVideoCount + 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item > currentRemoteVideoCount {
            return UICollectionViewCell()
        }

        let isSelf = indexPath.item == 0
        let videoTileState = getVideoTileState(for: indexPath)
        let displayName = getVideoTileDisplayName(for: indexPath)
        let isVideoActive = (videoTileState != nil)

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: videoTileCellReuseIdentifier,
                                                            for: indexPath) as? VideoTileCell else {
            return VideoTileCell()
        }

        cell.updateCell(name: displayName,
                        isSelf: isSelf,
                        isVideoActive: isVideoActive,
                        tag: indexPath.row)
        cell.delegate = self

        if let tileState = videoTileState {
            if tileState.isLocalTile, delegate?.isFrontCameraActive() ?? false {
                cell.videoRenderView.mirror = true
            }
            delegate?.bindVideoView(videoView: cell.videoRenderView, tileId: tileState.tileId)
        }

        return cell
    }
}

extension VideoModel: VideoTileCellDelegate {
    func onTileButtonClicked(tag: Int, selected: Bool) {
        if tag == 0 {
            delegate?.switchCamera()
        } else {
            if let tileState = getVideoTileState(for: IndexPath(item: tag, section: 0)), !tileState.isLocalTile {
                if selected {
                    delegate?.pauseVideo(tileId: tileState.tileId)
                } else {
                    delegate?.resumeVideo(tileId: tileState.tileId)
                }
            }
        }
    }
}
