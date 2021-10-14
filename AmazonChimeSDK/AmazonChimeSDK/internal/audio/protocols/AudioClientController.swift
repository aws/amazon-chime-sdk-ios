//
//  AudioClientController.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objc public protocol AudioClientController {
    func setMute(mute: Bool) -> Bool
    func start(audioFallbackUrl: String,
               audioHostUrl: String,
               meetingId: String,
               attendeeId: String,
               joinToken: String,
               callKitEnabled: Bool,
               audioMode: AudioMode) throws
    func stop()
    func setVoiceFocusEnabled(enabled: Bool) -> Bool
    func isVoiceFocusEnabled() -> Bool
    func promoteToPrimaryMeeting(credentials: MeetingSessionCredentials, observer: PrimaryMeetingPromotionObserver)
    func demoteFromPrimaryMeeting()
}
