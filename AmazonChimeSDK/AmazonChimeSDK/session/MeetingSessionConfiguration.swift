//
//  MeetingSessionConfiguration.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `MeetingSessionConfiguration` contains the information necessary to start a session.
/// Constructs a MeetingSessionConfiguration with a chime:`CreateMeetingResponse` and
/// chime:`CreateAttendeeResponse` response and optional custom `URLRewriter` that will
/// rewrite urls given to new urls.
@objcMembers public class MeetingSessionConfiguration: NSObject {
    /// The id of the meeting the session is joining.
    public let meetingId: String

    /// The credentials used to authenticate the session.
    public let credentials: MeetingSessionCredentials

    /// The URLs the session uses to reach the meeting service.
    public let urls: MeetingSessionURLs

    public let urlRewriter: URLRewriter

    public convenience init(createMeetingResponse: CreateMeetingResponse,
                            createAttendeeResponse: CreateAttendeeResponse) {
        self.init(createMeetingResponse: createMeetingResponse,
                  createAttendeeResponse: createAttendeeResponse,
                  urlRewriter: URLRewriterUtils.defaultUrlRewriter)
    }

    public init(createMeetingResponse: CreateMeetingResponse,
                createAttendeeResponse: CreateAttendeeResponse,
                urlRewriter: @escaping URLRewriter) {
        self.meetingId = createMeetingResponse.meeting.meetingId
        self.credentials = MeetingSessionCredentials(attendeeId: createAttendeeResponse.attendee.attendeeId,
                                                     joinToken: createAttendeeResponse.attendee.joinToken)
        self.urls = MeetingSessionURLs(audioFallbackUrl: createMeetingResponse.meeting.mediaPlacement.audioFallbackUrl,
                                       audioHostUrl: createMeetingResponse.meeting.mediaPlacement.audioHostUrl,
                                       turnControlUrl: createMeetingResponse.meeting.mediaPlacement.turnControlUrl,
                                       signalingUrl: createMeetingResponse.meeting.mediaPlacement.signalingUrl,
                                       urlRewriter: urlRewriter)
        self.urlRewriter = urlRewriter
    }
}
