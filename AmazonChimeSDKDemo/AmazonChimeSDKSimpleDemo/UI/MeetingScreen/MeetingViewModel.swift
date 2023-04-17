//
//  MeetingViewModel.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AmazonChimeSDK

class MeetingViewModel {
    
    var meetingId: String {
        get {
            return MeetingManager.shared.sessionStateStore.meetingId ?? ""
        }
    }
    
    var isMuted: Bool {
        get {
            return MeetingManager.shared.sessionStateStore.isMuted
        } set {
            self.meetingController.isMuted = newValue
        }
    }
    
    var attendees: [AttendeeInfo] {
        return MeetingManager.shared.sessionStateStore.attendees
    }
    
    var videoAttendeeIds: [String] {
        return MeetingManager.shared.sessionStateStore.videoAttendess
    }
    
    var isLocalVideoEnabled: Bool {
        guard let localAttendeeId = MeetingManager.shared.sessionStateStore.localAttendeeId else {
            return false
        }
        return MeetingManager.shared.sessionStateStore.videoTileStates[localAttendeeId] != nil
    }
    
    private let meetingController: MeetingController
    
    init(enableCallKit: Bool) {
        self.meetingController = MeetingControllerProvider.shared.getMeetingController(enableCallKit: enableCallKit)
    }
    
    func leaveMeeting() {
        self.meetingController.leaveMeeting()
    }
    
    func isAttendeeMuted(attendeeId: String) -> Bool {
        return MeetingManager.shared.sessionStateStore.muteStates[attendeeId] ?? false
    }
    
    func bindVideoTile(attendeeId: String, videoView: VideoRenderView) {
        self.meetingController.bindView(videoView: videoView, attendeeId: attendeeId)
    }
    
    func getAttendeeInfo(attendeeId: String) -> AttendeeInfo? {
        return MeetingManager.shared.sessionStateStore.attendees.first { attendeeInfo in
            return attendeeInfo.attendeeId == attendeeId
        }
    }
    
    func startLocalVideo() {
        self.meetingController.startLocalVideo()
    }
    
    func stopLocalVideo() {
        self.meetingController.stopLocalVideo()
    }
}
