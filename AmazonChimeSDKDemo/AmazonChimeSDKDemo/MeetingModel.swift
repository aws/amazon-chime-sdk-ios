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
        case captions
        case metrics
        case callKitOnHold
    }

    // Dependencies
    let meetingId: String
    let meetingEndpointUrl: String
    let primaryMeetingId: String
    let primaryExternalMeetingId: String
    let selfName: String
    var audioVideoConfig = AudioVideoConfiguration()
    let callKitOption: CallKitOption
    let meetingSessionConfig: MeetingSessionConfiguration
    lazy var currentMeetingSession = DefaultMeetingSession(configuration: meetingSessionConfig,
                                                           logger: logger)

    // Utils
    let logger = ConsoleLogger(name: "MeetingModel")
    let postLogger: PostLogger
    let activeSpeakerObserverId = UUID().uuidString

    // Sub models
    let rosterModel = RosterModel()
    lazy var videoModel = VideoModel(audioVideoFacade: currentMeetingSession.audioVideo,
                                     eventAnalyticsController: currentMeetingSession.eventAnalyticsController)
    let metricsModel = MetricsModel()
    lazy var screenShareModel = ScreenShareModel(meetingSessionConfig: meetingSessionConfig,
                                                 contentShareController: currentMeetingSession.audioVideo)
    let chatModel = ChatModel()
    lazy var deviceSelectionModel = DeviceSelectionModel(deviceController: currentMeetingSession.audioVideo,
                                                         cameraCaptureSource: videoModel.customSource,
                                                         audioVideoConfig: audioVideoConfig)
    let captionsModel = CaptionsModel()
    let uuid = UUID()
    var call: Call?

    // States
    var isAppInBackground: Bool = false {
        didSet {
            if isAppInBackground {
                wasLocalVideoOn = videoModel.isLocalVideoActive
                if wasLocalVideoOn {
                    videoModel.isLocalVideoActive = false
                }
                videoModel.pauseAllRemoteVideos()
            } else {
                if wasLocalVideoOn {
                    videoModel.isLocalVideoActive = true
                }
                videoModel.resumeAllRemoteVideosInCurrentPageExceptUserPausedVideos()
            }
        }
    }
    private var savedModeBeforeOnHold: ActiveMode?
    private var wasLocalVideoOn: Bool = false

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
            // This will unbind current tiles.
            videoModel.isEnded = true
            currentMeetingSession.audioVideo.stop()
            screenShareModel.stopLocalSharing()
            isEndedHandler?()
        }
    }

    // State for joining primary meeting will not be true until success,
    // which is achieved asynchronously.  Managed in `MeetingViewController`.
    var isPromotedToPrimaryMeeting = false
    // Store to adjust content takeover behavior
    var primaryMeetingMeetingSessionCredentials: MeetingSessionCredentials? = nil

    var audioDevices: [MediaDevice] {
        return currentMeetingSession.audioVideo.listAudioDevices()
    }

    var currentAudioDevice: MediaDevice? {
        return currentMeetingSession.audioVideo.getActiveAudioDevice()
    }

    // Handlers
    var activeModeDidSetHandler: ((ActiveMode) -> Void)?
    var notifyHandler: ((String) -> Void)?
    var isMutedHandler: ((Bool) -> Void)?
    var isEndedHandler: (() -> Void)?

    init(meetingSessionConfig: MeetingSessionConfiguration,
         meetingId: String,
         primaryMeetingId: String,
         primaryExternalMeetingId: String,
         selfName: String,
         audioVideoConfig: AudioVideoConfiguration,
         callKitOption: CallKitOption,
         meetingEndpointUrl: String) {
        self.meetingId = meetingId
        self.meetingEndpointUrl = meetingEndpointUrl.isEmpty ? AppConfiguration.url : meetingEndpointUrl
        self.primaryMeetingId = primaryMeetingId
        self.primaryExternalMeetingId = primaryExternalMeetingId
        self.selfName = selfName
        self.audioVideoConfig = audioVideoConfig
        self.callKitOption = callKitOption
        self.meetingSessionConfig = meetingSessionConfig
        let url = AppConfiguration.url.hasSuffix("/") ? AppConfiguration.url : "\(AppConfiguration.url)/"
        self.postLogger = PostLogger(name: "SDKEvents", configuration: meetingSessionConfig, url: "\(url)log_meeting_event")
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
            self.startAudioVideoConnection()
            self.currentMeetingSession.audioVideo.startRemoteVideo()
        }
        screenShareModel.broadcastCaptureModel.isBlocked = false
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

    func setVoiceFocusEnabled(enabled: Bool) {
        let action = enabled ? "enable" : "disable"
        let success = currentMeetingSession.audioVideo.realtimeSetVoiceFocusEnabled(enabled: enabled)
        if success {
            notify(msg: "Voice Focus \(action)d")
        } else {
            notify(msg: "Failed to \(action) Voice Focus")
        }
    }

    func isVoiceFocusEnabled() -> Bool {
        return currentMeetingSession.audioVideo.realtimeIsVoiceFocusEnabled()
    }
    
    func setLiveTranscriptionEnabled(enabled: Bool) {
        if enabled {
            MeetingModule.shared().liveTranscriptionOptionsSelected(self)
        } else {
            postStopTranscriptionRequest()
        }
    }
    
    func postStopTranscriptionRequest() {
        let url = self.meetingEndpointUrl.hasSuffix("/") ? self.meetingEndpointUrl : "\(self.meetingEndpointUrl)/"
        let encodedURL = HttpUtils.encodeStrForURL(
                str: "\(url)stop_transcription?title=\(meetingId)")
        HttpUtils.postRequest(url: encodedURL, jsonData: nil) { _, error in
            DispatchQueue.main.async {
                if error != nil {
                    self.notify(msg: "Transcription failed to stop, please try again!")
                } else {
                    self.notify(msg: "Live Transcription Disabled")
                }
            }
        }
    }

    func getVideoTileDisplayName(for indexPath: IndexPath) -> String {
        var displayName = ""
        if indexPath.item == 0 {
            if videoModel.isLocalVideoActive {
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
    
    func getVideoTileAttendeeId(for indexPath: IndexPath) -> String {
        if let videoTileState = videoModel.getVideoTileState(for: indexPath) {
            return videoTileState.attendeeId
        }
        return ""
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
        audioVideo.addEventAnalyticsObserver(observer: self)
        audioVideo.addRealtimeTranscriptEventObserver?(observer: self)
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
        audioVideo.removeEventAnalyticsObserver(observer: self)
        audioVideo.removeRealtimeTranscriptEventObserver?(observer: self)
    }

    private func configureAudioSession() {
        MeetingModule.shared().configureAudioSession()
    }

    private func startAudioVideoConnection() {
        do {
            setupAudioVideoFacadeObservers()
            try currentMeetingSession.audioVideo.start(audioVideoConfiguration: audioVideoConfig)
        } catch {
            logger.error(msg: "Error starting the Meeting: \(error.localizedDescription)")
            endMeeting()
        }
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
            self?.startAudioVideoConnection()
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
        logWithFunctionName(message: "reconnecting \(reconnecting)")
        // Start Amazon Voice Focus as soon as audio session started
        setVoiceFocusEnabled(enabled: true)
        if !reconnecting {
            call?.isConnectedHandler?()
        }

        // This selection has to be here because if there are bluetooth headset connected,
        // selecting non-bluetooth device before audioVideo.start() will get route overwritten by bluetooth
        // after audio session starts
        chooseAudioDevice(deviceSelectionModel.selectedAudioDevice)
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
    
    func remoteVideoSourcesDidBecomeAvailable(sources: [RemoteVideoSource]) {
        logWithFunctionName()
        sources.forEach { source in
            // Initialize with defaults in case we want to update through UI
            videoModel.remoteVideoSourceConfigurations[source] = VideoSubscriptionConfiguration()
        }
        // Use default auto-subscribe behavior
    }
    
    func remoteVideoSourcesDidBecomeUnavailable(sources: [RemoteVideoSource]) {
        logWithFunctionName()
        sources.forEach { source in
            videoModel.remoteVideoSourceConfigurations.removeValue(forKey: source)
        }
    }

    func videoSessionDidStartWithStatus(sessionStatus: MeetingSessionStatus) {
        switch sessionStatus.statusCode {
        case .videoAtCapacityViewOnly:
            notifyHandler?("Local video is no longer possible to be enabled")
            logWithFunctionName(message: "\(sessionStatus.statusCode)")
            videoModel.isLocalVideoActive = false
        default:
            logWithFunctionName(message: "\(sessionStatus.statusCode)")
        }
    }
}

// MARK: RealtimeObserver

extension MeetingModel: RealtimeObserver {
    private func isSelfAttendee(attendeeId: String) -> Bool {
        return DefaultModality(id: attendeeId).base == meetingSessionConfig.credentials.attendeeId
            || DefaultModality(id: attendeeId).base == primaryMeetingMeetingSessionCredentials?.attendeeId
    }

    private func removeAttendeesAndReload(attendeeInfo: [AttendeeInfo]) {
        let attendeeIds = attendeeInfo.map { $0.attendeeId }
        rosterModel.removeAttendees(attendeeIds)
        if activeMode == .roster {
            rosterModel.rosterUpdatedHandler?()
        }
    }

    private func attendeesDidJoinWithStatus(attendeeInfo: [AttendeeInfo], status: AttendeeStatus) {
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
                var action = "Joined"
                logger.info(msg: "attendeeId:\(currentAttendeeInfo.attendeeId) externalUserId:\(currentAttendeeInfo.externalUserId) \(action)")

                // if other attendee starts sharing content, stop content sharing from current device
                let modality = DefaultModality(id: attendeeId)
                if modality.isOfType(type: .content),
                   !isSelfAttendee(attendeeId: attendeeId) {
                    screenShareModel.stopLocalSharing()
                    notifyHandler?("\(rosterModel.getAttendeeName(for: modality.base) ?? "") took over the screen share")
                }
            }
        }
        rosterModel.addAttendees(newAttendees)
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
        attendeesDidJoinWithStatus(attendeeInfo: attendeeInfo, status: AttendeeStatus.joined)
    }
}

// MARK: MetricsObserver

extension MeetingModel: MetricsObserver {
    func metricsDidReceive(metrics: [AnyHashable: Any]) {
        guard let observableMetrics = metrics as? [ObservableMetric: Any] else {
            logger.error(msg: "The received metrics \(metrics) is not of type [ObservableMetric: Any].")
            return
        }
        metricsModel.updateAppMetrics(metrics: metrics)
        logger.info(msg: "Media metrics have been received: \(observableMetrics)")
        if activeMode == .metrics {
            metricsModel.metricsUpdatedHandler?()
        }
    }
}

// MARK: DeviceChangeObserver

extension MeetingModel: DeviceChangeObserver {
    func audioDeviceDidChange(freshAudioDeviceList: [MediaDevice]) {
        let deviceLabels: [String] = freshAudioDeviceList.map { device in "* \(device.label) (\(device.type))" }
        logger.info(msg: deviceLabels.joined(separator: "\n"))
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
                videoModel.addRemoteVideoTileState(tileState, completion: {
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
        if tileState.pauseState == .pausedForPoorConnection {
            videoModel.updateRemoteVideoTileState(tileState)
        } else {
            let attendeeId = tileState.attendeeId
            let attendeeName = rosterModel.getAttendeeName(for: attendeeId) ?? ""
            notifyHandler?("Video for attendee \(attendeeName) " +
                " has been paused")
        }
    }

    func videoTileDidResume(tileState: VideoTileState) {
        let attendeeId = tileState.attendeeId
        let attendeeName = rosterModel.getAttendeeName(for: attendeeId) ?? ""
        notifyHandler?("Video for attendee \(attendeeName) has been unpaused")
        videoModel.updateRemoteVideoTileState(tileState)
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
        videoModel.updateRemoteVideoStatesBasedOnActiveSpeakers(activeSpeakers: attendeeInfo, inVideoMode: activeMode == .video)

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
        if dataMessage.topic == "chat" {
            chatModel.addDataMessage(dataMessage: dataMessage)
        }
    }
}

extension MeetingModel: EventAnalyticsObserver {
    func eventDidReceive(name: EventName, attributes: [AnyHashable: Any]) {
        let jsonData = try? JSONSerialization.data(withJSONObject: [
            "name": "\(name)",
            "attributes": toStringKeyDict(attributes.merging(currentMeetingSession.audioVideo.getCommonEventAttributes(),
                                                             uniquingKeysWith: { (_, newVal) -> Any in
                newVal
            }))
        ], options: [])

        guard let data = jsonData, let msg = String(data: data, encoding: .utf8)  else {
            logger.info(msg: "Dictionary is not in correct format to be serialized")
            return
        }
        postLogger.info(msg: msg)

        switch name {
        case .meetingStartSucceeded:
            logger.info(msg: "Meeting stared on : \(currentMeetingSession.audioVideo.getCommonEventAttributes().toJsonString())")
        case .meetingEnded, .meetingFailed:
            logger.info(msg: "\(currentMeetingSession.audioVideo.getMeetingHistory())")
            postLogger.publishLog()
        default:
            break
        }
    }

    func toStringKeyDict(_ attributes: [AnyHashable: Any]) -> [String: Any] {
        var jsonDict = [String: Any]()
        attributes.forEach { (key, value) in
            jsonDict[String(describing: key)] = String(describing: value)
        }
        return jsonDict
    }
}

// MARK: TranscriptEventObserver

extension MeetingModel: TranscriptEventObserver {
    func transcriptEventDidReceive(transcriptEvent: TranscriptEvent) {
        captionsModel.addTranscriptEvent(transcriptEvent: transcriptEvent)
    }
}
