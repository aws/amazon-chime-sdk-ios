//
//  DefaultMeetingController.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AmazonChimeSDK

class DefaultMeetingController: MeetingController {
    
    private let meetingManager = MeetingManager.shared
    
    var isMuted: Bool {
        get {
            return meetingManager.isMuted
        } set {
            meetingManager.isMuted = newValue
        }
    }
    
    func joinMeeting(meetingId: String,
                     attendeeName: String,
                     succeeded: @escaping () -> Void,
                     failed: @escaping (Error) -> Void) {
        self.meetingManager.joinMeeting(meetingId: meetingId,
                                        attendeeName: attendeeName,
                                        enableCallKit: false,
                                        enableVoiceFocus: true,
                                        succeeded: succeeded,
                                        failed: failed)
    }
    
    func leaveMeeting() {
        self.meetingManager.leaveMeeting()
    }
    
    func startLocalVideo() {
        self.meetingManager.startLocalVideo()
    }
    
    func stopLocalVideo() {
        self.meetingManager.stopLocalVideo()
    }
    
    func bindView(videoView: VideoRenderView, attendeeId: String) {
        self.meetingManager.bindVideo(videoView: videoView, attendeeId: attendeeId)
    }
}
