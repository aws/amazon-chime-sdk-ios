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
    let primaryMeetingId: String?

    public convenience init(externalMeetingId: String?,
                            mediaPlacement: MediaPlacement,
                            mediaRegion: String,
                            meetingId: String) {
        self.init(
            externalMeetingId: externalMeetingId,
            mediaPlacement: mediaPlacement,
            mediaRegion: mediaRegion,
            meetingId: meetingId,
            primaryMeetingId: nil)
    }

    public init(externalMeetingId: String?,
                 mediaPlacement: MediaPlacement,
                 mediaRegion: String,
                 meetingId: String,
                 primaryMeetingId: String?) {
        self.externalMeetingId = externalMeetingId
        self.mediaPlacement = mediaPlacement
        self.mediaRegion = mediaRegion
        self.meetingId = meetingId
        self.primaryMeetingId = primaryMeetingId
    }
}

@objcMembers public class MediaPlacement: NSObject {
    let audioFallbackUrl: String
    let audioHostUrl: String
    let signalingUrl: String
    let turnControlUrl: String
    let eventIngestionUrl: String?

    public convenience init(audioFallbackUrl: String, audioHostUrl: String, signalingUrl: String, turnControlUrl: String) {
        self.init(audioFallbackUrl: audioFallbackUrl,
                  audioHostUrl: audioHostUrl,
                  signalingUrl: signalingUrl,
                  turnControlUrl: turnControlUrl,
                  eventIngestionUrl: nil)
    }

    public init(audioFallbackUrl: String,
                audioHostUrl: String,
                signalingUrl: String,
                turnControlUrl: String,
                eventIngestionUrl: String?) {
        self.audioFallbackUrl = audioFallbackUrl
        self.audioHostUrl = audioHostUrl
        self.signalingUrl = signalingUrl
        self.turnControlUrl = turnControlUrl
        self.eventIngestionUrl = eventIngestionUrl
    }
}
