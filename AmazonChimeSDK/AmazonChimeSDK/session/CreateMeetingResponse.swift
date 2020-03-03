//
//  CreateAttendeeResponse.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

@objcMembers public class CreateMeetingResponse: NSObject {
    let meeting: Meeting

    public init(meeting: Meeting) {
        self.meeting = meeting
    }
}

@objcMembers public class Meeting: NSObject {
    let meetingId: String
    let mediaPlacement: MediaPlacement

    public init(meetingId: String, mediaPlacement: MediaPlacement) {
        self.meetingId = meetingId
        self.mediaPlacement = mediaPlacement
    }
}

@objcMembers public class MediaPlacement: NSObject {
    let audioFallbackUrl: String
    let audioHostUrl: String
    let turnControlUrl: String
    let signalingUrl: String

    public init(audioFallbackUrl: String, audioHostUrl: String, turnControlUrl: String, signalingUrl: String) {
        self.audioFallbackUrl = audioFallbackUrl
        self.audioHostUrl = audioHostUrl
        self.turnControlUrl = turnControlUrl
        self.signalingUrl = signalingUrl
    }
}
