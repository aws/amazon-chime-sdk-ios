//
//  CreateAttendeeResponse.swift
//  AmazonChimeSDK
//
//  Created by Wang, Haoran on 1/11/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
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

    public init(audioHostURL: String) {
        self.audioHostURL = audioHostURL
    }
}
