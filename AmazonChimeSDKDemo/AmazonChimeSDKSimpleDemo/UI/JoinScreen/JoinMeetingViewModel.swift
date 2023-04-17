//
//  JoinMeetingViewModel.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

class JoinMeetingViewModel {
    
    func join(meetingId: String,
              attendeeName: String,
              enableCallKit: Bool,
              succeeded: @escaping () -> Void,
              failed: @escaping (Error) -> Void) {
        let meetingController = MeetingControllerProvider.shared.getMeetingController(enableCallKit: enableCallKit)
        
        meetingController.joinMeeting(meetingId: meetingId,
                                   attendeeName: attendeeName,
                                   succeeded: succeeded,
                                   failed: failed)
    }
}
