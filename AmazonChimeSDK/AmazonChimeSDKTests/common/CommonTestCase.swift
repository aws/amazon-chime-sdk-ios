//
//  CommonTestCase.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class CommonTestCase: XCTestCase {
    let externalMeetingId = "external-meeting-id"
    let audioFallbackUrl = "audioFallbackUrl"
    let audioHostUrlWithPort = "audio-host-url:2020"
    let audioHostUrl = "audio-host-url"
    let signalingUrl = "signalingUrl"
    let turnControlUrl = "turnControlUrl"
    let mediaRegion = "us-east-1"
    let meetingId = "meeting-id"
    let attendeeId = "attendee-id"
    let externalUserId = "externalUserId"
    let joinToken = "join-token"

    var meetingSessionConfigurationMock: MeetingSessionConfigurationMock!
    var loggerMock: LoggerMock!

    override func setUp() {
        let mediaPlacementMock: MediaPlacementMock = mock(MediaPlacement.self)
            .initialize(audioFallbackUrl: audioFallbackUrl,
                        audioHostUrl: audioHostUrlWithPort,
                        signalingUrl: signalingUrl,
                        turnControlUrl: turnControlUrl, eventIngestionUrl: nil)
        let meetingMock: MeetingMock = mock(Meeting.self).initialize(externalMeetingId: externalMeetingId,
                                                                     mediaPlacement: mediaPlacementMock,
                                                                     mediaRegion: mediaRegion,
                                                                     meetingId: meetingId,
                                                                     primaryMeetingId: nil)
        let createMeetingResponseMock: CreateMeetingResponseMock = mock(CreateMeetingResponse.self)
            .initialize(meeting: meetingMock)

        let attendeeMock: AttendeeMock = mock(Attendee.self).initialize(attendeeId: attendeeId,
                                                                        externalUserId: externalUserId,
                                                                        joinToken: joinToken)
        let createAttendeeResponseMock: CreateAttendeeResponseMock = mock(CreateAttendeeResponse.self)
            .initialize(attendee: attendeeMock)
        meetingSessionConfigurationMock = mock(MeetingSessionConfiguration.self)
            .initialize(createMeetingResponse: createMeetingResponseMock,
                        createAttendeeResponse: createAttendeeResponseMock,
                        urlRewriter: URLRewriterUtils.defaultUrlRewriter)
        loggerMock = mock(Logger.self)
    }
}
