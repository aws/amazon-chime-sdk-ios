//
//  MeetingModel.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import AVFoundation
import UIKit

class MeetingModel: NSObject {
    enum ActiveMode {
        case roster
        case chat
        case video
        case screenShare
        case metrics
        case callKitOnHold
    }

    // Dependencies
    let meetingId: String
    let selfName: String
    let callKitOption: CallKitOption
    let meetingSessionConfig: MeetingSessionConfiguration
    lazy var currentMeetingSession = DefaultMeetingSession(configuration: meetingSessionConfig, logger: logger)

    // Utils
    let logger = ConsoleLogger(name: "MeetingModel")
    let activeSpeakerObserverId = UUID().uuidString

    // Sub models
    let rosterModel = RosterModel()
    lazy var videoModel = VideoModel(audioVideoFacade: currentMeetingSession.audioVideo)
    let metricsModel = MetricsModel()
    let screenShareModel = ScreenShareModel()
    let chatModel = ChatModel()
    let uuid = UUID()
    var call: Call?

    private var savedModeBeforeOnHold: ActiveMode?

    // States
    var activeMode: ActiveMode = .roster {
        didSet {
            if activeMode == .video {
                videoModel.resumeAllRemoteVideosInCurrentPageExceptUserPausedVideos()
            } else {
                videoModel.pauseAllRemoteVideos()
            }
            activeModeDidSetHandler?(activeMode)
        }
    }

    private var isMuted = false {
        didSet {
            if isMuted {
                if currentMeetingSession.audioVideo.realtimeLocalMute() {
                    logger.info(msg: "Microphone has been muted")
                }
            } else {
                if currentMeetingSession.audioVideo.realtimeLocalUnmute() {
                    logger.info(msg: "Microphone has been unmuted")
                }
            }
            isMutedHandler?(isMuted)
        }
    }

    private var isEnded = false {
        didSet {
            currentMeetingSession.audioVideo.stop()
            isEndedHandler?()
        }
    }

    var audioDevices: [MediaDevice] {
        return currentMeetingSession.audioVideo.listAudioDevices()
    }

    var isLocalVideoActive = false {
        didSet {
            if isLocalVideoActive {
                startLocalVideo()
            } else {
                stopLocalVideo()
            }
        }
    }

    var isFrontCameraActive: Bool {
        if let activeCamera = currentMeetingSession.audioVideo.getActiveCamera() {
            return activeCamera.type == .videoFrontCamera
        }
        return false
    }

    // Handlers
    var activeModeDidSetHandler: ((ActiveMode) -> Void)?
    var notifyHandler: ((String) -> Void)?
    var isMutedHandler: ((Bool) -> Void)?
    var isEndedHandler: (() -> Void)?

    init(meetingSessionConfig: MeetingSessionConfiguration, meetingId: String, selfName: String, callKitOption: CallKitOption) {
        self.meetingId = meetingId
        self.selfName = selfName
        self.callKitOption = callKitOption
        self.meetingSessionConfig = meetingSessionConfig
        super.init()

        if callKitOption == .incoming {
            call = createCall(isOutgoing: false)
        } else if callKitOption == .outgoing {
            call = createCall(isOutgoing: true)
        }
    }

    func bind(videoRenderView: VideoRenderView, tileId: Int) {
        currentMeetingSession.audioVideo.bindVideoView(videoView: videoRenderView, tileId: tileId)
    }

    func startMeeting() {
        if self.callKitOption == .disabled {
            self.configureAudioSession()
            self.startAudioVideoConnection(isCallKitEnabled: false)
            self.currentMeetingSession.audioVideo.startRemoteVideo()
        }
    }

    func resumeCallKitMeeting() {
        if let call = call {
            CallKitManager.shared().setHeld(with: call, isOnHold: false)
        }
    }

    func endMeeting() {
        if let call = call, !isEnded {
            CallKitManager.shared().endCallFromLocal(with: call)
        } else {
            isEnded = true
        }
    }

    func setMute(isMuted: Bool) {
        if let call = call {
            CallKitManager.shared().setMuted(for: call, isMuted: isMuted)
        } else {
            self.isMuted = isMuted
        }
    }

    func getVideoTileDisplayName(for indexPath: IndexPath) -> String {
        var displayName = ""
        if indexPath.item == 0 {
            if isLocalVideoActive {
                displayName = selfName
            } else {
                displayName = "Turn on your video"
            }
        } else {
            if let videoTileState = videoModel.getVideoTileState(for: indexPath) {
                displayName = rosterModel.getAttendeeName(for: videoTileState.attendeeId) ?? ""
            }
        }
        return displayName
    }

    func chooseAudioDevice(_ audioDevice: MediaDevice) {
        currentMeetingSession.audioVideo.chooseAudioDevice(mediaDevice: audioDevice)
    }

    func sendDataMessage(_ message: String) {
        do {
             try currentMeetingSession
                 .audioVideo
                 .realtimeSendDataMessage(topic: "chat",
                                          data: message,
                                          lifetimeMs: 1000)
         } catch {
             logger.error(msg: "Failed to send message!")
             return
         }

         let currentTimestamp = NSDate().timeIntervalSince1970
         let timestamp = TimeStampConversion.formatTimestamp(timestamp: Int64(currentTimestamp) * 1000)

         chatModel
             .addChatMessage(chatMessage:
                 ChatMessage(
                     senderName: self.selfName,
                     message: message,
                     timestamp: timestamp,
                     isSelf: true
             ))
    }

    private func notify(msg: String) {
        logger.info(msg: msg)
        notifyHandler?(msg)
    }

    private func logWithFunctionName(fnName: String = #function, message: String = "") {
        logger.info(msg: "[Function] \(fnName) -> \(message)")
    }

    private func setupAudioVideoFacadeObservers() {
        let audioVideo = currentMeetingSession.audioVideo
        audioVideo.addVideoTileObserver(observer: self)
        audioVideo.addRealtimeObserver(observer: self)
        audioVideo.addAudioVideoObserver(observer: self)
        audioVideo.addMetricsObserver(observer: self)
        audioVideo.addDeviceChangeObserver(observer: self)
        audioVideo.addActiveSpeakerObserver(policy: DefaultActiveSpeakerPolicy(),
                                            observer: self)
        audioVideo.addRealtimeDataMessageObserver(topic: "chat", observer: self)
    }

    private func removeAudioVideoFacadeObservers() {
        let audioVideo = currentMeetingSession.audioVideo
        audioVideo.removeVideoTileObserver(observer: self)
        audioVideo.removeRealtimeObserver(observer: self)
        audioVideo.removeAudioVideoObserver(observer: self)
        audioVideo.removeMetricsObserver(observer: self)
        audioVideo.removeDeviceChangeObserver(observer: self)
        audioVideo.removeActiveSpeakerObserver(observer: self)
        audioVideo.removeRealtimeDataMessageObserverFromTopic(topic: "chat")
    }

    private func configureAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            if audioSession.category != .playAndRecord {
                try audioSession.setCategory(AVAudioSession.Category.playAndRecord,
                                             options: AVAudioSession.CategoryOptions.allowBluetooth)
            }
            if audioSession.mode != .voiceChat {
                try audioSession.setMode(.voiceChat)
            }
        } catch {
            logger.error(msg: "Error configuring AVAudioSession: \(error.localizedDescription)")
            endMeeting()
        }
    }

    private func startAudioVideoConnection(isCallKitEnabled: Bool) {
        do {
            setupAudioVideoFacadeObservers()
            try currentMeetingSession.audioVideo.start(callKitEnabled: isCallKitEnabled)
        } catch {
            logger.error(msg: "Error starting the Meeting: \(error.localizedDescription)")
            endMeeting()
        }
    }

    private func startLocalVideo() {
        MeetingModule.shared().requestVideoPermission { success in
            if success {
                do {
                    try self.currentMeetingSession.audioVideo.startLocalVideo()
                } catch {
                    self.logger.error(msg: "Error starting local video: \(error.localizedDescription)")
                }
            }
        }
    }

    private func stopLocalVideo() {
        currentMeetingSession.audioVideo.stopLocalVideo()
    }

    private func logAttendee(attendeeInfo: [AttendeeInfo], action: String) {
        for currentAttendeeInfo in attendeeInfo {
            let attendeeId = currentAttendeeInfo.attendeeId
            if !rosterModel.contains(attendeeId: attendeeId) {
                logger.error(msg: "Cannot find attendee with attendee id \(attendeeId)" +
                    " external user id \(currentAttendeeInfo.externalUserId): \(action)")
                continue
            }
            logger.info(msg: "\(rosterModel.getAttendeeName(for: attendeeId) ?? "nil"): \(action)")
        }
    }

    private func createCall(isOutgoing: Bool) -> Call {
        let call = Call(uuid: uuid, handle: meetingId, isOutgoing: isOutgoing)
        call.isReadytoConfigureHandler = { [weak self] in
            self?.configureAudioSession()
        }
        call.isAudioSessionActiveHandler = { [weak self] in
            self?.startAudioVideoConnection(isCallKitEnabled: true)
            self?.currentMeetingSession.audioVideo.startRemoteVideo()
            if self?.isMuted ?? false {
                _ = self?.currentMeetingSession.audioVideo.realtimeLocalMute()
            }
        }
        call.isEndedHandler = { [weak self] in
            self?.isEnded = true
        }
        call.isMutedHandler = { [weak self] isMuted in
            self?.isMuted = isMuted
        }
        call.isOnHoldHandler = { [weak self] isOnHold in
            if isOnHold {
                self?.currentMeetingSession.audioVideo.stop()
                self?.savedModeBeforeOnHold = self?.activeMode
                self?.activeMode = .callKitOnHold
            } else {
                if let savedModeBeforeOnHold = self?.savedModeBeforeOnHold {
                    self?.activeMode = savedModeBeforeOnHold
                    self?.savedModeBeforeOnHold = nil
                }
            }
        }
        return call
    }
}

// MARK: AudioVideoObserver

extension MeetingModel: AudioVideoObserver {
    func connectionDidRecover() {
        notifyHandler?("Connection quality has recovered")
        logWithFunctionName()
    }

    func connectionDidBecomePoor() {
        notifyHandler?("Connection quality has become poor")
        logWithFunctionName()
    }

    func videoSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus) {
        logWithFunctionName(message: "\(sessionStatus.statusCode)")
    }

    func audioSessionDidStartConnecting(reconnecting: Bool) {
        notifyHandler?("Audio started connecting. Reconnecting: \(reconnecting)")
        logWithFunctionName(message: "reconnecting \(reconnecting)")
        if !reconnecting {
            call?.isConnectingHandler?()
        }
    }

    func audioSessionDidStart(reconnecting: Bool) {
        notifyHandler?("Audio successfully started. Reconnecting: \(reconnecting)")
        logWithFunctionName(message: "reconnecting \(reconnecting), device \(currentMeetingSession.audioVideo.getActiveAudioDevice()?.label ?? "none")")
        if !reconnecting {
            call?.isConnectedHandler?()
        }
    }

    func audioSessionDidDrop() {
        notifyHandler?("Audio Session Dropped")
        logWithFunctionName()
    }

    func audioSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus) {
        logWithFunctionName(message: "\(sessionStatus.statusCode)")

        removeAudioVideoFacadeObservers()
        if let call = call {
            switch sessionStatus.statusCode {
            case .ok:
                if call.isOnHold {
                    return
                }
            case .audioCallEnded, .audioServerHungup:
                CallKitManager.shared().reportCallEndedFromRemote(with: call, reason: .remoteEnded)
            case .audioJoinedFromAnotherDevice:
                CallKitManager.shared().reportCallEndedFromRemote(with: call, reason: .answeredElsewhere)
            case .audioDisconnectAudio:
                CallKitManager.shared().reportCallEndedFromRemote(with: call, reason: .declinedElsewhere)
            default:
                CallKitManager.shared().reportCallEndedFromRemote(with: call, reason: .failed)
            }
        }
        endMeeting()
    }

    func audioSessionDidCancelReconnect() {
        notifyHandler?("Audio cancelled reconnecting")
        logWithFunctionName()
    }

    func videoSessionDidStartConnecting() {
        logWithFunctionName()
    }

    func videoSessionDidStartWithStatus(sessionStatus: MeetingSessionStatus) {
        switch sessionStatus.statusCode {
        case .videoAtCapacityViewOnly:
            notifyHandler?("Maximum concurrent video limit reached! Failed to start local video")
            logWithFunctionName(message: "\(sessionStatus.statusCode)")
        default:
            logWithFunctionName(message: "\(sessionStatus.statusCode)")
        }
    }
}

// MARK: RealtimeObserver

extension MeetingModel: RealtimeObserver {
    private func removeAttendeesAndReload(attendeeInfo: [AttendeeInfo]) {
        let attendeeIds = attendeeInfo.map { $0.attendeeId }
        rosterModel.removeAttendees(attendeeIds)
        if activeMode == .roster {
            rosterModel.rosterUpdatedHandler?()
        }
    }

    func attendeesDidLeave(attendeeInfo: [AttendeeInfo]) {
        logAttendee(attendeeInfo: attendeeInfo, action: "Left")
        removeAttendeesAndReload(attendeeInfo: attendeeInfo)
    }

    func attendeesDidDrop(attendeeInfo: [AttendeeInfo]) {
        for attendee in attendeeInfo {
            notify(msg: "\(attendee.externalUserId) dropped")
        }

        removeAttendeesAndReload(attendeeInfo: attendeeInfo)
    }

    func attendeesDidMute(attendeeInfo: [AttendeeInfo]) {
        logAttendee(attendeeInfo: attendeeInfo, action: "Muted")
    }

    func attendeesDidUnmute(attendeeInfo: [AttendeeInfo]) {
        logAttendee(attendeeInfo: attendeeInfo, action: "Unmuted")
    }

    func volumeDidChange(volumeUpdates: [VolumeUpdate]) {
        for currentVolumeUpdate in volumeUpdates {
            let attendeeId = currentVolumeUpdate.attendeeInfo.attendeeId
            rosterModel.updateVolume(attendeeId: attendeeId, volume: currentVolumeUpdate.volumeLevel)
        }
        if activeMode == .roster {
            rosterModel.rosterUpdatedHandler?()
        }
    }

    func signalStrengthDidChange(signalUpdates: [SignalUpdate]) {
        for currentSignalUpdate in signalUpdates {
            logWithFunctionName(message: "\(currentSignalUpdate.attendeeInfo.externalUserId) \(currentSignalUpdate.signalStrength)")
            let attendeeId = currentSignalUpdate.attendeeInfo.attendeeId
            rosterModel.updateSignal(attendeeId: attendeeId, signal: currentSignalUpdate.signalStrength)
        }
        if activeMode == .roster {
            rosterModel.rosterUpdatedHandler?()
        }
    }

    func attendeesDidJoin(attendeeInfo: [AttendeeInfo]) {
        var newAttendees = [RosterAttendee]()
        for currentAttendeeInfo in attendeeInfo {
            let attendeeId = currentAttendeeInfo.attendeeId
            if !rosterModel.contains(attendeeId: attendeeId) {
                let attendeeName = RosterModel.convertAttendeeName(from: currentAttendeeInfo)
                let newAttendee = RosterAttendee(attendeeId: attendeeId,
                                                 attendeeName: attendeeName,
                                                 volume: .notSpeaking,
                                                 signal: .high)
                newAttendees.append(newAttendee)
            }
        }
        rosterModel.addAttendees(newAttendees)
        if activeMode == .roster {
            rosterModel.rosterUpdatedHandler?()
        }
    }
}

// MARK: MetricsObserver

extension MeetingModel: MetricsObserver {
    func metricsDidReceive(metrics: [AnyHashable: Any]) {
        guard let observableMetrics = metrics as? [ObservableMetric: Any] else {
            logger.error(msg: "The received metrics \(metrics) is not of type [ObservableMetric: Any].")
            return
        }
        metricsModel.update(dict: metrics)
        logger.info(msg: "Media metrics have been received: \(observableMetrics)")
        if activeMode == .metrics {
            metricsModel.metricsUpdatedHandler?()
        }
    }
}

// MARK: DeviceChangeObserver

extension MeetingModel: DeviceChangeObserver {
    func audioDeviceDidChange(freshAudioDeviceList: [MediaDevice]) {
        let deviceLabels: [String] = freshAudioDeviceList.map { device in "* \(device.label)" }
        notifyHandler?("Device availability changed:\nAvailable Devices:\n\(deviceLabels.joined(separator: "\n"))")
    }
}

// MARK: VideoTileObserver

extension MeetingModel: VideoTileObserver {
    func videoTileDidAdd(tileState: VideoTileState) {
        logger.info(msg: "Attempting to add video tile tileId: \(tileState.tileId)" +
            " attendeeId: \(tileState.attendeeId) with size \(tileState.videoStreamContentWidth)*\(tileState.videoStreamContentHeight)")
        if tileState.isContent {
            screenShareModel.tileId = tileState.tileId
            if activeMode == .screenShare {
                screenShareModel.viewUpdateHandler?(true)
            }
        } else {
            if tileState.isLocalTile {
                videoModel.setSelfVideoTileState(tileState)
                if activeMode == .video {
                    videoModel.localVideoUpdatedHandler?()
                }
            } else {
                videoModel.addRemoteVideoTileState(tileState, completion: { success in
                    if success {
                        if self.activeMode == .video {
                            // If the video is not currently being displayed, pause it
                            if !self.videoModel.isRemoteVideoDisplaying(tileId: tileState.tileId) {
                                self.currentMeetingSession.audioVideo.pauseRemoteVideoTile(tileId: tileState.tileId)
                            }
                            self.videoModel.videoUpdatedHandler?()
                        } else {
                            // Currently not in the video view, no need to render the video tile
                            self.currentMeetingSession.audioVideo.pauseRemoteVideoTile(tileId: tileState.tileId)
                        }
                    } else {
                        self.logger.info(msg: "Cannot add more video tile tileId: \(tileState.tileId)")
                    }
                })
            }
        }
    }

    func videoTileDidRemove(tileState: VideoTileState) {
        logger.info(msg: "Attempting to remove video tile tileId: \(tileState.tileId)" +
            " attendeeId: \(tileState.attendeeId)")
        currentMeetingSession.audioVideo.unbindVideoView(tileId: tileState.tileId)

        if tileState.isContent {
            screenShareModel.tileId = nil
            if activeMode == .screenShare {
                screenShareModel.viewUpdateHandler?(false)
            }
        } else if tileState.isLocalTile {
            videoModel.setSelfVideoTileState(nil)
            if activeMode == .video {
                videoModel.localVideoUpdatedHandler?()
            }
        } else {
            videoModel.removeRemoteVideoTileState(tileState, completion: { success in
                if success {
                    self.videoModel.revalidateRemoteVideoPageIndex()
                    if self.activeMode == .video {
                        self.videoModel.videoUpdatedHandler?()
                    }
                } else {
                    self.logger.error(msg: "Cannot remove unexisting remote video tile for tileId: \(tileState.tileId)")
                }
            })
        }
    }

    func videoTileDidPause(tileState: VideoTileState) {
        let attendeeId = tileState.attendeeId
        let attendeeName = rosterModel.getAttendeeName(for: attendeeId) ?? ""
        if tileState.pauseState == .pausedForPoorConnection {
            notifyHandler?("Video for attendee \(attendeeName) " +
                " has been paused for poor network connection," +
                " video will automatically resume when connection improves")
        } else {
            notifyHandler?("Video for attendee \(attendeeName) " +
                " has been paused")
        }
    }

    func videoTileDidResume(tileState: VideoTileState) {
        let attendeeId = tileState.attendeeId
        let attendeeName = rosterModel.getAttendeeName(for: attendeeId) ?? ""
        notifyHandler?("Video for attendee \(attendeeName) has been unpaused")
    }

    func videoTileSizeDidChange(tileState: VideoTileState) {
        logger.info(msg: "Video stream content size changed to \(tileState.videoStreamContentWidth)*\(tileState.videoStreamContentHeight) for tileId: \(tileState.tileId)")
    }
}

// MARK: ActiveSpeakerObserver

extension MeetingModel: ActiveSpeakerObserver {
    var observerId: String {
        return activeSpeakerObserverId
    }

    var scoresCallbackIntervalMs: Int {
        return 5000 // 5 second
    }

    func activeSpeakerDidDetect(attendeeInfo: [AttendeeInfo]) {
        videoModel.updateRemoteVideoStatesBasedOnActiveSpeakers(activeSpeakers: attendeeInfo)
        if activeMode == .video {
            videoModel.videoUpdatedHandler?()
        }

        rosterModel.updateActiveSpeakers(attendeeInfo.map { $0.attendeeId })
        if activeMode == .roster {
            rosterModel.rosterUpdatedHandler?()
        }
    }

    func activeSpeakerScoreDidChange(scores: [AttendeeInfo: Double]) {
        let scoresInString = scores.map { (score) -> String in
            let (key, value) = score
            return "\(key.externalUserId): \(value)"
        }.joined(separator: ",")
        logWithFunctionName(message: "\(scoresInString)")
    }
}

// MARK: DataMessageObserver

extension MeetingModel: DataMessageObserver {
    func dataMessageDidReceived(dataMessage: DataMessage) {
        chatModel.addDataMessage(dataMessage: dataMessage)
    }
}
