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

    /// The external id of the meeting the session is joining. See https://docs.aws.amazon.com/chime/latest/APIReference/API_CreateMeeting.html#API_CreateMeeting_RequestSyntax for more details
    public let externalMeetingId: String?

    /// The credentials used to authenticate the session.
    public let credentials: MeetingSessionCredentials

    /// The URLs the session uses to reach the meeting service.
    public let urls: MeetingSessionURLs

    public let urlRewriter: URLRewriter

    /// The id of the primary meeting that this session is joining a replica to
    public let primaryMeetingId: String?

    public convenience init(createMeetingResponse: CreateMeetingResponse,
                            createAttendeeResponse: CreateAttendeeResponse) {
        self.init(createMeetingResponse: createMeetingResponse,
                  createAttendeeResponse: createAttendeeResponse,
                  urlRewriter: URLRewriterUtils.defaultUrlRewriter)
    }

    public convenience init(meetingId: String,
                            credentials: MeetingSessionCredentials,
                            urls: MeetingSessionURLs,
                            urlRewriter: @escaping URLRewriter) {
        self.init(meetingId: meetingId,
                  externalMeetingId: nil,
                  credentials: credentials,
                  urls: urls,
                  urlRewriter: urlRewriter)
    }

    public convenience init(meetingId: String,
                            externalMeetingId: String?,
                            credentials: MeetingSessionCredentials,
                            urls: MeetingSessionURLs,
                            urlRewriter: @escaping URLRewriter) {
        self.init(meetingId: meetingId,
                  externalMeetingId: externalMeetingId,
                  credentials: credentials,
                  urls: urls,
                  urlRewriter: urlRewriter,
                  primaryMeetingId: nil)
    }

    public init(meetingId: String,
                externalMeetingId: String?,
                credentials: MeetingSessionCredentials,
                urls: MeetingSessionURLs,
                urlRewriter: @escaping URLRewriter,
                primaryMeetingId: String?) {
        self.meetingId = meetingId
        self.externalMeetingId = externalMeetingId
        self.credentials = credentials
        self.urls = urls
        self.urlRewriter = urlRewriter
        self.primaryMeetingId = primaryMeetingId
    }
    

    public init(createMeetingResponse: CreateMeetingResponse,
                createAttendeeResponse: CreateAttendeeResponse,
                urlRewriter: @escaping URLRewriter) {
        self.meetingId = createMeetingResponse.meeting.meetingId
        self.externalMeetingId = createMeetingResponse.meeting.externalMeetingId
        self.primaryMeetingId = createMeetingResponse.meeting.primaryMeetingId
        self.credentials = MeetingSessionCredentials(attendeeId: createAttendeeResponse.attendee.attendeeId,
                                                     externalUserId: createAttendeeResponse.attendee.externalUserId,
                                                     joinToken: createAttendeeResponse.attendee.joinToken)
        self.urls = MeetingSessionURLs(audioFallbackUrl: createMeetingResponse.meeting.mediaPlacement.audioFallbackUrl,
                                       audioHostUrl: createMeetingResponse.meeting.mediaPlacement.audioHostUrl,
                                       turnControlUrl: createMeetingResponse.meeting.mediaPlacement.turnControlUrl,
                                       signalingUrl: createMeetingResponse.meeting.mediaPlacement.signalingUrl,
                                       urlRewriter: urlRewriter,
                                       ingestionUrl: createMeetingResponse.meeting.mediaPlacement.eventIngestionUrl)
        self.urlRewriter = urlRewriter
    }
}
