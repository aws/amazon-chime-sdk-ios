//
//  MeetingControllerProvider.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

class MeetingControllerProvider {
    
    static let shared = MeetingControllerProvider()
    
    private lazy var defaultMeetingController: MeetingController = {
        return DefaultMeetingController()
    } ()
    
    private lazy var callKitMeetingController: MeetingController = {
        return CallKitMeetingController()
    } ()
    
    func getMeetingController(enableCallKit: Bool) -> MeetingController {
        if enableCallKit {
            return self.callKitMeetingController
        }
        return self.defaultMeetingController
    }
}
