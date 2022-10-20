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

    let uuid = UUID()
    var call: Call?

    private var savedModeBeforeOnHold: ActiveMode?
    private var wasLocalVideoOn: Bool = false

    var activeMode: ActiveMode = .roster {
        didSet {
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
            currentMeetingSession.audioVideo.stop()
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

    func chooseAudioDevice(_ audioDevice: MediaDevice) {
        currentMeetingSession.audioVideo.chooseAudioDevice(mediaDevice: audioDevice)
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
    }

    private func removeAudioVideoFacadeObservers() {
        let audioVideo = currentMeetingSession.audioVideo
        audioVideo.removeVideoTileObserver(observer: self)
        audioVideo.removeRealtimeObserver(observer: self)
        audioVideo.removeAudioVideoObserver(observer: self)
        audioVideo.removeMetricsObserver(observer: self)
        audioVideo.removeDeviceChangeObserver(observer: self)
        audioVideo.removeActiveSpeakerObserver(observer: self)
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
        // Use default auto-subscribe behavior
    }
 
    func remoteVideoSourcesDidBecomeUnavailable(sources: [RemoteVideoSource]) {
        logWithFunctionName()
    }

    func videoSessionDidStartWithStatus(sessionStatus: MeetingSessionStatus) {
        switch sessionStatus.statusCode {
        case .videoAtCapacityViewOnly:
            notifyHandler?("Local video is no longer possible to be enabled")
            logWithFunctionName(message: "\(sessionStatus.statusCode)")
        default:
            logWithFunctionName(message: "\(sessionStatus.statusCode)")
        }
    }

    func cameraSendAvailabilityDidChange(available : Bool) {
        logWithFunctionName(message: "Camera Send Available: \(available)")
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
                let action = "Joined"
                logger.info(msg: "attendeeId:\(currentAttendeeInfo.attendeeId) externalUserId:\(currentAttendeeInfo.externalUserId) \(action)")

                // if other attendee starts sharing content, stop content sharing from current device

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
        logger.info(msg: "Media metrics have been received: \(observableMetrics)")
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
    }

    func videoTileDidRemove(tileState: VideoTileState) {
        logger.info(msg: "Attempting to remove video tile tileId: \(tileState.tileId)" +
            " attendeeId: \(tileState.attendeeId)")
    }

    func videoTileDidPause(tileState: VideoTileState) {
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
