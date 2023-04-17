//
//  MeetingController.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AmazonChimeSDK

protocol MeetingController: AnyObject {
    
    var isMuted: Bool { get set }
    
    func joinMeeting(meetingId: String,
                     attendeeName: String,
                     succeeded: @escaping () -> Void,
                     failed: @escaping (_ error: Error) -> Void)
    
    func leaveMeeting()
    
    func startLocalVideo()
    
    func stopLocalVideo()
    
    func bindView(videoView: VideoRenderView, attendeeId: String)
}
