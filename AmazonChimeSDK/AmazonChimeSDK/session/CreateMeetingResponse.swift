//
//  CreateAttendeeResponse.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers public class CreateMeetingResponse: NSObject {
    let meeting: Meeting

    public init(meeting: Meeting) {
        self.meeting = meeting
    }
}

@objcMembers public class Meeting: NSObject {
    let externalMeetingId: String?
    let mediaPlacement: MediaPlacement
    let mediaRegion: String
    let meetingId: String

    public init(externalMeetingId: String?, mediaPlacement: MediaPlacement, mediaRegion: String, meetingId: String) {
        self.externalMeetingId = externalMeetingId
        self.mediaPlacement = mediaPlacement
        self.mediaRegion = mediaRegion
        self.meetingId = meetingId
    }
}

@objcMembers public class MediaPlacement: NSObject {
    let audioFallbackUrl: String
    let audioHostUrl: String
    let signalingUrl: String
    let turnControlUrl: String

    public init(audioFallbackUrl: String, audioHostUrl: String, signalingUrl: String, turnControlUrl: String) {
        self.audioFallbackUrl = audioFallbackUrl
        self.audioHostUrl = audioHostUrl
        self.signalingUrl = signalingUrl
        self.turnControlUrl = turnControlUrl
    }
}
