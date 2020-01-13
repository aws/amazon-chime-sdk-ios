//
//  CreateAttendeeResponse.swift
//  AmazonChimeSDK
//
//  Created by Wang, Haoran on 1/11/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

import Foundation

public struct CreateMeetingResponse {
    var meeting: Meeting

    public init(meeting: Meeting) {
        self.meeting = meeting
    }
}

public struct Meeting {
    var meetingId: String
    var mediaPlacement: MediaPlacement

    public init(meetingId: String, mediaPlacement: MediaPlacement) {
        self.meetingId = meetingId
        self.mediaPlacement = mediaPlacement
    }
}

public struct MediaPlacement {
    var audioHostUrl: String

    public init(audioHostUrl: String) {
        self.audioHostUrl = audioHostUrl
    }
}
