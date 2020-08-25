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
    private let remoteVideoTileCountPerPage = 2

    private var remoteVideoPageNumber = 1

    private var selfVideoTileState: VideoTileState?
    private var remoteVideoTileStates: [(Int, VideoTileState)] = []
    private var userPausedVideoTileIds: Set<Int> = Set()
    private let audioVideoFacade: AudioVideoFacade

    var videoUpdatedHandler: (() -> Void)?
    var localVideoUpdatedHandler: (() -> Void)?

    init(audioVideoFacade: AudioVideoFacade) {
        self.audioVideoFacade = audioVideoFacade
        super.init()
    }

    var videoTileCount: Int {
        return remoteVideoCountInCurrentPage + 1
    }

    private var currentRemoteVideoCount: Int {
        return remoteVideoTileStates.count
    }

    var remoteVideoStatesInCurrentPage: [(Int, VideoTileState)] {
        let remoteVideoStartIndex = (remoteVideoPageNumber - 1) * remoteVideoTileCountPerPage
        let remoteVideoEndIndex = min(currentRemoteVideoCount, remoteVideoStartIndex + remoteVideoTileCountPerPage) - 1

        if remoteVideoEndIndex < remoteVideoStartIndex {
            return []
        }
        return Array(remoteVideoTileStates[remoteVideoStartIndex...remoteVideoEndIndex])
    }

    private var remoteVideoStatesNotInCurrentPage: [(Int, VideoTileState)] {
        let remoteVideoAttendeeIdsInCurrentPage = Set(remoteVideoStatesInCurrentPage.map { $0.1.attendeeId })
        return remoteVideoTileStates.filter { !remoteVideoAttendeeIdsInCurrentPage.contains($0.1.attendeeId) }
    }

    private var remoteVideoCountInCurrentPage: Int {
        return remoteVideoStatesInCurrentPage.count
    }

    private var isMaximumRemoteVideoReached: Bool {
        return currentRemoteVideoCount >= maxRemoteVideoTileCount
    }

    func updateRemoteVideoStatesBasedOnActiveSpeakers(activeSpeakers: [AttendeeInfo]) {
        let activeSpeakerIds = Set(activeSpeakers.map { $0.attendeeId })

        // Cast to NSArray to make sure the sorting implementation is stable
        remoteVideoTileStates = (remoteVideoTileStates as NSArray).sortedArray(options: .stable,
                                                                               usingComparator: { (lhs, rhs) -> ComparisonResult in
            let lhsIsActiveSpeaker = activeSpeakerIds.contains((lhs as? (Int, VideoTileState))?.1.attendeeId ?? "")
            let rhsIsActiveSpeaker = activeSpeakerIds.contains((rhs as? (Int, VideoTileState))?.1.attendeeId ?? "")

            if lhsIsActiveSpeaker == rhsIsActiveSpeaker {
                return ComparisonResult.orderedSame
            } else if lhsIsActiveSpeaker && !rhsIsActiveSpeaker {
                return ComparisonResult.orderedAscending
            } else {
                return ComparisonResult.orderedDescending
            }
        }) as? [(Int, VideoTileState)] ?? []

        for remoteVideoTileState in remoteVideoStatesNotInCurrentPage {
            audioVideoFacade.pauseRemoteVideoTile(tileId: remoteVideoTileState.0)
        }
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

    func getPreviousRemoteVideoPage(completion: @escaping (Bool) -> Void) {
        if remoteVideoPageNumber <= 1 {
            completion(false)
            return
        }

        for remoteVideoTileState in remoteVideoStatesInCurrentPage {
            audioVideoFacade.pauseRemoteVideoTile(tileId: remoteVideoTileState.0)
        }
        remoteVideoPageNumber -= 1
        completion(true)
    }

    func getNextRemoteVideoPage(completion: @escaping (Bool) -> Void) {
        let maxPageNumber = Int(ceil(Double(currentRemoteVideoCount) / Double(remoteVideoTileCountPerPage)))
        if remoteVideoPageNumber >= maxPageNumber {
            completion(false)
            return
        }

        for remoteVideoTileState in remoteVideoStatesInCurrentPage {
            audioVideoFacade.pauseRemoteVideoTile(tileId: remoteVideoTileState.0)
        }
        remoteVideoPageNumber += 1
        completion(true)
    }

    func revalidateRemoteVideoPageNumber() {
        while remoteVideoPageNumber != 1, remoteVideoCountInCurrentPage == 0 {
            getPreviousRemoteVideoPage(completion: { _ in })
        }
    }

    func resumeAllRemoteVideosInCurrentPageExceptUserPausedVideos() {
        for remoteVideoTileState in remoteVideoStatesInCurrentPage {
            if !userPausedVideoTileIds.contains(remoteVideoTileState.0) {
                audioVideoFacade.resumeRemoteVideoTile(tileId: remoteVideoTileState.0)
            }
        }
    }

    func pauseAllRemoteVideos() {
        for remoteVideoTileState in remoteVideoTileStates {
            audioVideoFacade.pauseRemoteVideoTile(tileId: remoteVideoTileState.0)
        }
    }

    func getVideoTileState(for indexPath: IndexPath) -> VideoTileState? {
        if indexPath.item == 0 {
            return selfVideoTileState
        }
        if indexPath.item > remoteVideoTileCountPerPage {
            return nil
        }
        return remoteVideoStatesInCurrentPage[indexPath.item - 1].1
    }
}

extension VideoModel: VideoTileCellDelegate {
    func onTileButtonClicked(tag: Int, selected: Bool) {
        if tag == 0 {
            audioVideoFacade.switchCamera()
        } else {
            if let tileState = getVideoTileState(for: IndexPath(item: tag, section: 0)), !tileState.isLocalTile {
                if selected {
                    userPausedVideoTileIds.insert(tileState.tileId)
                    audioVideoFacade.pauseRemoteVideoTile(tileId: tileState.tileId)
                } else {
                    userPausedVideoTileIds.remove(tileState.tileId)
                    audioVideoFacade.resumeRemoteVideoTile(tileId: tileState.tileId)
                }
            }
        }
    }
}
