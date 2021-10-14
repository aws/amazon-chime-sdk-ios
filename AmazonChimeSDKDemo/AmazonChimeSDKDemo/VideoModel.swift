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
    private let remoteVideoTileCountPerPage = 6

    private var currentRemoteVideoPageIndex = 0

    private var selfVideoTileState: VideoTileState?
    private var remoteVideoTileStates: [(Int, VideoTileState)] = []
    private var userPausedVideoTileIds: Set<Int> = Set()
    public var remoteVideoSourceConfigurations: Dictionary<RemoteVideoSource, VideoSubscriptionConfiguration> = Dictionary()
    private let audioVideoFacade: AudioVideoFacade
    let customSource: DefaultCameraCaptureSource

    var videoUpdatedHandler: (() -> Void)?
    var localVideoUpdatedHandler: (() -> Void)?
    let logger = ConsoleLogger(name: "VideoModel")

    init(audioVideoFacade: AudioVideoFacade, eventAnalyticsController: EventAnalyticsController) {
        self.audioVideoFacade = audioVideoFacade
        self.customSource = DefaultCameraCaptureSource(logger: ConsoleLogger(name: "CustomCameraSource"))
        self.customSource.setEventAnalyticsController(eventAnalyticsController: eventAnalyticsController)
        super.init()
    }

    var videoTileCount: Int {
        return remoteVideoCountInCurrentPage + 1
    }

    var canGoToPrevRemoteVideoPage: Bool {
        return currentRemoteVideoPageIndex > 0
    }

    var canGoToNextRemoteVideoPage: Bool {
        let maxRemoteVideoPageIndex = Int(ceil(Double(currentRemoteVideoCount) / Double(remoteVideoTileCountPerPage))) - 1
        return currentRemoteVideoPageIndex < maxRemoteVideoPageIndex
    }

    var isLocalVideoActive = false {
        willSet(isLocalVideoActive) {
            if isLocalVideoActive {
                customSource.start()
                startLocalVideo()
            } else {
                customSource.stop()
                stopLocalVideo()
            }
        }
    }

    var isEnded = false {
        didSet(isEnded) {
            if isEnded {
                for tile in remoteVideoTileStates {
                    audioVideoFacade.unbindVideoView(tileId: tile.0)
                }
                if isLocalVideoActive, let selfTile = selfVideoTileState {
                    audioVideoFacade.unbindVideoView(tileId: selfTile.tileId)
                }

                if isUsingExternalVideoSource {
                    self.customSource.removeVideoSink(sink: self.coreImageVideoProcessor)
                    if isUsingMetalVideoProcessor, let metalProcessor = self.metalVideoProcessor {
                        self.customSource.removeVideoSink(sink: metalProcessor)
                    }
                }

                isLocalVideoActive = false

                audioVideoFacade.stopRemoteVideo()
                customSource.torchEnabled = false
            }
        }
    }

    var isFrontCameraActive: Bool {
        // See comments above isUsingExternalVideoSource
        if let internalCamera = audioVideoFacade.getActiveCamera() {
            return internalCamera.type == .videoFrontCamera
        }
        if let activeCamera = customSource.device {
            return activeCamera.type == .videoFrontCamera
        }
        return false
    }

    // To facilitate demoing and testing both use cases, we account for both our external
    // camera and the camera managed by the facade. Actual applications should
    // only use one or the other
    var isUsingExternalVideoSource = true {
        didSet {
            if isLocalVideoActive {
                startLocalVideo()
            }
        }
    }

    private let coreImageVideoProcessor = CoreImageVideoProcessor()
    var isUsingCoreImageVideoProcessor = false {
        didSet {
            if isLocalVideoActive {
                startLocalVideo()
            }
        }
    }

    // See comments in MetalVideoProcessor
    private let metalVideoProcessor = MetalVideoProcessor()
    var isUsingMetalVideoProcessor = false {
        didSet {
            if isLocalVideoActive {
                startLocalVideo()
            }
        }
    }

    private var currentRemoteVideoCount: Int {
        return remoteVideoTileStates.count
    }

    private var remoteVideoStatesInCurrentPage: [(Int, VideoTileState)] {
        let remoteVideoStartIndex = currentRemoteVideoPageIndex * remoteVideoTileCountPerPage
        let remoteVideoEndIndex = min(currentRemoteVideoCount, remoteVideoStartIndex + remoteVideoTileCountPerPage) - 1

        if remoteVideoEndIndex < remoteVideoStartIndex {
            return []
        }
        return Array(remoteVideoTileStates[remoteVideoStartIndex ... remoteVideoEndIndex])
    }

    private var remoteVideoStatesNotInCurrentPage: [(Int, VideoTileState)] {
        let remoteVideoAttendeeIdsInCurrentPage = Set(remoteVideoStatesInCurrentPage.map { $0.1.attendeeId })
        return remoteVideoTileStates.filter { !remoteVideoAttendeeIdsInCurrentPage.contains($0.1.attendeeId) }
    }

    private var remoteVideoCountInCurrentPage: Int {
        return remoteVideoStatesInCurrentPage.count
    }

    private func startLocalVideo() {
        MeetingModule.shared().requestVideoPermission { success in
            if success {
                // See comments above isUsingExternalVideoSource
                if self.isUsingExternalVideoSource {
                    var customVideoSource: VideoSource = self.customSource
                    customVideoSource.removeVideoSink(sink: self.coreImageVideoProcessor)
                    if let metalVideoProcessor = self.metalVideoProcessor {
                        customVideoSource.removeVideoSink(sink: metalVideoProcessor)
                    }
                    if self.isUsingCoreImageVideoProcessor {
                        customVideoSource.addVideoSink(sink: self.coreImageVideoProcessor)
                        customVideoSource = self.coreImageVideoProcessor
                    } else if self.isUsingMetalVideoProcessor, let metalVideoProcessor = self.metalVideoProcessor {
                        customVideoSource.addVideoSink(sink: metalVideoProcessor)
                        customVideoSource = metalVideoProcessor
                    }
                    self.audioVideoFacade.startLocalVideo(source: customVideoSource)
                } else {
                    do {
                        try self.audioVideoFacade.startLocalVideo()
                    } catch {
                        self.logger.error(msg: "Error starting local video: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    private func stopLocalVideo() {
        audioVideoFacade.stopLocalVideo()
        // See comments above isUsingExternalVideoSource
        if isUsingExternalVideoSource {
            customSource.stop()
        }
    }

    func promoteToPrimaryMeeting(credentials: MeetingSessionCredentials, observer: PrimaryMeetingPromotionObserver) {
        audioVideoFacade.promoteToPrimaryMeeting(credentials: credentials, observer: observer)
    }

    func demoteFromPrimaryMeeting() {
        audioVideoFacade.demoteFromPrimaryMeeting()
    }

    func isRemoteVideoDisplaying(tileId: Int) -> Bool {
        return remoteVideoStatesInCurrentPage.contains(where: { $0.0 == tileId })
    }

    func updateRemoteVideoStatesBasedOnActiveSpeakers(activeSpeakers: [AttendeeInfo], inVideoMode: Bool = false) {
        let activeSpeakerIds = Set(activeSpeakers.map { $0.attendeeId })
        var videoTilesOrderUpdated = false

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
                videoTilesOrderUpdated = true
                return ComparisonResult.orderedDescending
            }
        }) as? [(Int, VideoTileState)] ?? []

        for remoteVideoTileState in remoteVideoStatesNotInCurrentPage {
            audioVideoFacade.pauseRemoteVideoTile(tileId: remoteVideoTileState.0)
        }

        if videoTilesOrderUpdated && inVideoMode {
            videoUpdatedHandler?()
        }
    }

    func setSelfVideoTileState(_ videoTileState: VideoTileState?) {
        selfVideoTileState = videoTileState
    }

    func addRemoteVideoTileState(_ videoTileState: VideoTileState, completion: @escaping () -> Void) {
        remoteVideoTileStates.append((videoTileState.tileId, videoTileState))
        completion()
    }

    func removeRemoteVideoTileState(_ videoTileState: VideoTileState, completion: @escaping (Bool) -> Void) {
        if let index = remoteVideoTileStates.firstIndex(where: { $0.0 == videoTileState.tileId }) {
            remoteVideoTileStates.remove(at: index)
            completion(true)
        } else {
            completion(false)
        }
    }

    func updateRemoteVideoTileState(_ videoTileState: VideoTileState) {
        if let index = remoteVideoTileStates.firstIndex(where: { $0.0 == videoTileState.tileId }) {
            remoteVideoTileStates[index] = (videoTileState.tileId, videoTileState)
            videoUpdatedHandler?()
        }
    }

    func getPreviousRemoteVideoPage() {
        for remoteVideoTileState in remoteVideoStatesInCurrentPage {
            audioVideoFacade.pauseRemoteVideoTile(tileId: remoteVideoTileState.0)
        }
        currentRemoteVideoPageIndex -= 1
    }

    func getNextRemoteVideoPage() {
        for remoteVideoTileState in remoteVideoStatesInCurrentPage {
            audioVideoFacade.pauseRemoteVideoTile(tileId: remoteVideoTileState.0)
        }
        currentRemoteVideoPageIndex += 1
    }

    func revalidateRemoteVideoPageIndex() {
        while canGoToPrevRemoteVideoPage, remoteVideoCountInCurrentPage == 0 {
            getPreviousRemoteVideoPage()
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

    func toggleTorch() -> Bool {
        let desiredState = !customSource.torchEnabled
        customSource.torchEnabled = desiredState
        return customSource.torchEnabled == desiredState
    }
}

extension VideoModel: VideoTileCellDelegate {
    func onTileButtonClicked(tag: Int, selected: Bool) {
        if tag == 0 {
            // See comments above MeetingModel::isUsingExternalVideoSource
            if audioVideoFacade.getActiveCamera() != nil {
                audioVideoFacade.switchCamera()
            } else {
                customSource.switchCamera()
            }
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

    func onUpdatePriorityButtonClicked(attendeeId: String, priority: VideoPriority) {
        for (source, config) in remoteVideoSourceConfigurations {
            if attendeeId == source.attendeeId {
                config.priority = priority
            }
        }
        audioVideoFacade.updateVideoSourceSubscriptions(addedOrUpdated: remoteVideoSourceConfigurations, removed: [])
    }
}
