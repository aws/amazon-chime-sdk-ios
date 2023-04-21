//
//  MeetingManager.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AmazonChimeSDK

class MeetingManager {
    
    static let shared = MeetingManager()
    
    let sessionStateStore: SessionStateStore = SessionStateStore()
    
    private let meetingNftCenter = MeetingNotificationCenter.shared
    
    private let logger = ConsoleLogger(name: "MeetingManager")
    
    private let deviceHelper = DefaultDeviceHelper()
    
    var isMuted: Bool {
        get {
            return self.sessionStateStore.isMuted
        } set {
            if self.sessionStateStore.isMuted == newValue {
                return
            }
            guard let session = self.sessionStateStore.session else {
                return
            }
            guard let attendeeId = self.sessionStateStore.localAttendeeId else {
                return
            }
            if newValue, session.audioVideo.realtimeLocalMute() {
                self.sessionStateStore.setMuteState(attendeeId: attendeeId, isMuted: newValue)
            } else if session.audioVideo.realtimeLocalUnmute() {
                self.sessionStateStore.setMuteState(attendeeId: attendeeId, isMuted: newValue)
            }
        }
    }
    
    func joinMeeting(meetingId: String,
                     attendeeName: String,
                     enableCallKit: Bool,
                     enableVoiceFocus: Bool,
                     succeeded: @escaping () -> Void,
                     failed: @escaping (_ error: Error) -> Void) {
        self.sessionStateStore.clear()
        
        self.sessionStateStore.meetingId = meetingId
        self.sessionStateStore.localAttendeeName = attendeeName
        
        deviceHelper.requestAudioPermissionIfNeeded { error in
            if let error = error {
                failed(error)
                return
            }
        }
        
        guard let joinMeetingResp = joinMeeting(meetingId: meetingId, attendeeName: attendeeName) else {
            failed(Errors.failedToJoinMeeting)
            return
        }
        self.sessionStateStore.localAttendeeId = joinMeetingResp.joinInfo.attendee.attendee.attendeeId
        
        let meetingResp = JoinRequestService.getCreateMeetingResponse(from: joinMeetingResp)
        let attendeeResp = JoinRequestService.getCreateAttendeeResponse(from: joinMeetingResp)
        let meetingSessionConfig = MeetingSessionConfiguration(createMeetingResponse: meetingResp,
                                                               createAttendeeResponse: attendeeResp,
                                                               urlRewriter: URLRewriterUtils.defaultUrlRewriter)
        do {
            try startMeeting(config: meetingSessionConfig,
                              enableCallKit: enableCallKit,
                              enableVoiceFocus: enableVoiceFocus)
            
            succeeded()
        }catch {
            failed(Errors.failedToStartMeetingSession)
        }
    }
    
    func leaveMeeting() {
        self.sessionStateStore.session?.audioVideo.stop()
        self.sessionStateStore.clear()
        self.meetingNftCenter.notifyMeetingEnded()
    }
    
    private func joinMeeting(meetingId: String, attendeeName: String) -> JoinMeetingResponse? {
        var result: JoinMeetingResponse?
        
        let group = DispatchGroup()
        group.enter()
        
        JoinRequestService.postJoinRequest(meetingId: meetingId,
                                           name: attendeeName,
                                           overriddenEndpoint: "",
                                           primaryExternalMeetingId: "") { response in
            result = response
            group.leave()
        }
        group.wait()
        
        return result
    }
    
    private func startMeeting(config: MeetingSessionConfiguration,
                              enableCallKit: Bool,
                              enableVoiceFocus: Bool) throws {
        let session = DefaultMeetingSession(configuration: config, logger: self.logger)
        session.audioVideo.addAudioVideoObserver(observer: self)
        session.audioVideo.addRealtimeObserver(observer: self)
        session.audioVideo.addVideoTileObserver(observer: self)
        self.sessionStateStore.session = session
        try session.audioVideo.start(callKitEnabled: enableCallKit)
        if !session.audioVideo.realtimeSetVoiceFocusEnabled(enabled: enableVoiceFocus) {
            self.logger.error(msg: "Failed to toggle voice focus")
        }
        session.audioVideo.startRemoteVideo()
    }
    
    func startLocalVideo() {
        self.deviceHelper.requestCameraPermissionIfNeeded { [weak self] _ in
            try? self?.sessionStateStore.session?.audioVideo.startLocalVideo()
        }
    }
    
    func stopLocalVideo() {
        self.sessionStateStore.session?.audioVideo.stopLocalVideo()
    }
    
    func bindVideo(videoView: VideoRenderView, attendeeId: String) {
        if let videoTile = self.sessionStateStore.videoTileStates[attendeeId] {
            self.sessionStateStore.session?.audioVideo.bindVideoView(videoView: videoView, tileId:
                                                                        videoTile.tileId)
        }
    }
}

extension MeetingManager: AudioVideoObserver {
    
    func audioSessionDidStartConnecting(reconnecting: Bool) {}
    
    func audioSessionDidStart(reconnecting: Bool) {}
    
    func audioSessionDidDrop() {}
    
    func audioSessionDidStopWithStatus(sessionStatus: AmazonChimeSDK.MeetingSessionStatus) {}
    
    func audioSessionDidCancelReconnect() {}
    
    func connectionDidRecover() {}
    
    func connectionDidBecomePoor() {}
    
    func videoSessionDidStartConnecting() {}
    
    func videoSessionDidStartWithStatus(sessionStatus: AmazonChimeSDK.MeetingSessionStatus) {}
    
    func videoSessionDidStopWithStatus(sessionStatus: AmazonChimeSDK.MeetingSessionStatus) {}
    
    func remoteVideoSourcesDidBecomeAvailable(sources: [AmazonChimeSDK.RemoteVideoSource]) {}
    
    func remoteVideoSourcesDidBecomeUnavailable(sources: [AmazonChimeSDK.RemoteVideoSource]) {}
    
    func cameraSendAvailabilityDidChange(available: Bool) {}
}

extension MeetingManager: RealtimeObserver {
    
    func volumeDidChange(volumeUpdates: [AmazonChimeSDK.VolumeUpdate]) {}
    
    func signalStrengthDidChange(signalUpdates: [AmazonChimeSDK.SignalUpdate]) {}
    
    func attendeesDidJoin(attendeeInfo: [AmazonChimeSDK.AttendeeInfo]) {
        self.sessionStateStore.addAttendees(attendees: attendeeInfo)
    }
    
    func attendeesDidLeave(attendeeInfo: [AmazonChimeSDK.AttendeeInfo]) {
        self.sessionStateStore.removeAttendees(attendeesToRemove: attendeeInfo)
    }
    
    func attendeesDidDrop(attendeeInfo: [AmazonChimeSDK.AttendeeInfo]) {
        self.sessionStateStore.removeAttendees(attendeesToRemove: attendeeInfo)
    }
    
    func attendeesDidMute(attendeeInfo: [AmazonChimeSDK.AttendeeInfo]) {
        for attendee in attendeeInfo {
            self.sessionStateStore.setMuteState(attendeeId: attendee.attendeeId, isMuted: true)
        }
    }
    
    func attendeesDidUnmute(attendeeInfo: [AmazonChimeSDK.AttendeeInfo]) {
        for attendee in attendeeInfo {
            self.sessionStateStore.setMuteState(attendeeId: attendee.attendeeId, isMuted: false)
        }
    }
}

extension MeetingManager: VideoTileObserver {
    
    func videoTileDidAdd(tileState: AmazonChimeSDK.VideoTileState) {
        let attendeeId = tileState.attendeeId
        self.sessionStateStore.addVideoTileState(attendeeId: attendeeId,
                                                 tileState: tileState)
    }
    
    func videoTileDidRemove(tileState: AmazonChimeSDK.VideoTileState) {
        let attendeeId = tileState.attendeeId
        self.sessionStateStore.removeVideoTileState(attendeeId: attendeeId)
    }
    
    func videoTileDidPause(tileState: AmazonChimeSDK.VideoTileState) {}
    
    func videoTileDidResume(tileState: AmazonChimeSDK.VideoTileState) {}
    
    func videoTileSizeDidChange(tileState: AmazonChimeSDK.VideoTileState) {}
}
