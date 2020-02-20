//
//  MeetingSessionConfiguration.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

public class MeetingSessionConfiguration {
    public let meetingId: String
    public let credentials: MeetingSessionCredentials
    public let urls: MeetingSessionURLs

    public init(createMeetingResponse: CreateMeetingResponse, createAttendeeResponse: CreateAttendeeResponse) {
        self.meetingId = createMeetingResponse.meeting.meetingId
        self.credentials = MeetingSessionCredentials(attendeeId: createAttendeeResponse.attendee.attendeeId,
                                                     joinToken: createAttendeeResponse.attendee.joinToken)
        self.urls = MeetingSessionURLs(audioFallbackUrl: createMeetingResponse.meeting.mediaPlacement.audioFallbackUrl,
                                       audioHostUrl: createMeetingResponse.meeting.mediaPlacement.audioHostUrl)
    }
}
