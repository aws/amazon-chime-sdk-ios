//
//  CreateAttendeeResponse.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

public struct CreateMeetingResponse {
    let meeting: Meeting

    public init(meeting: Meeting) {
        self.meeting = meeting
    }
}

public struct Meeting {
    let meetingId: String
    let mediaPlacement: MediaPlacement

    public init(meetingId: String, mediaPlacement: MediaPlacement) {
        self.meetingId = meetingId
        self.mediaPlacement = mediaPlacement
    }
}

public struct MediaPlacement {
    let audioHostURL: String
    let turnControlURL: String
    let signalingURL: String

    public init(audioHostURL: String, turnControlURL: String, signalingURL: String) {
        self.audioHostURL = audioHostURL
        self.turnControlURL = turnControlURL
        self.signalingURL = signalingURL
    }
}
