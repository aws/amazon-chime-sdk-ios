//
//  BroadcastScreenCaptureModel.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import Foundation

class BroadcastScreenCaptureModel {
    let meetingSessionConfig: MeetingSessionConfiguration
    let appGroupUserDefaults = UserDefaults(suiteName: AppConfiguration.appGroupId)
    let userDefaultsKeyMeetingId = "demoMeetingId"
    let userDefaultsKeyExternalMeetingId = "demoExternalMeetingId"
    let userDefaultsKeyCredentials = "demoMeetingCredentials"
    let userDefaultsKeyUrls = "demoMeetingUrls"
    let logger = ConsoleLogger(name: "BroadcastScreenCaptureModel")
    var observer: NSKeyValueObservation?

    var isBlocked = true {
        willSet(newValue) {
            if newValue == isBlocked {
                return
            }
            if newValue {
                deleteMeetingSessionConfigFromUserDefaults()
            } else {
                saveMeetingSessionConfigToUserDefaults()
            }
        }
    }

    init(meetingSessionConfig: MeetingSessionConfiguration) {
        self.meetingSessionConfig = meetingSessionConfig
    }

    // Broadcast extension is retrieving data from shared App Group User Defaults
    // to recreate the MeetingSessionConfig and share device level content.
    // See AmazonChimeSDKDemoBroadcast/SampleHandler for more details.
    private func saveMeetingSessionConfigToUserDefaults() {
        guard let appGroupUserDefaults = appGroupUserDefaults else {
            logger.error(msg: "App Group User Defaults not found")
            return
        }
        appGroupUserDefaults.set(meetingSessionConfig.meetingId, forKey: userDefaultsKeyMeetingId)
        appGroupUserDefaults.set(meetingSessionConfig.externalMeetingId ?? "", forKey: userDefaultsKeyExternalMeetingId)
        let encoder = JSONEncoder()
        if let credentials = try? encoder.encode(meetingSessionConfig.credentials) {
            appGroupUserDefaults.set(credentials, forKey: userDefaultsKeyCredentials)
        }
        if let urls = try? encoder.encode(meetingSessionConfig.urls) {
            appGroupUserDefaults.set(urls, forKey: userDefaultsKeyUrls)
        }
    }

    private func deleteMeetingSessionConfigFromUserDefaults() {
        guard let appGroupUserDefaults = appGroupUserDefaults else {
            logger.error(msg: "App Group User Defaults not found")
            return
        }
        appGroupUserDefaults.removeObject(forKey: userDefaultsKeyMeetingId)
        appGroupUserDefaults.removeObject(forKey: userDefaultsKeyExternalMeetingId)
        appGroupUserDefaults.removeObject(forKey: userDefaultsKeyCredentials)
        appGroupUserDefaults.removeObject(forKey: userDefaultsKeyUrls)
    }
}
