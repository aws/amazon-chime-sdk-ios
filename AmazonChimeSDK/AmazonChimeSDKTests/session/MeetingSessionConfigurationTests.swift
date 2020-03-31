//
//  MeetingSessionConfigurationTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class MeetingSessionConfigurationTests: XCTestCase {
    private let audioFallbackStr = "audioFallbackUrl"
    private let audioHostStr = "audioHostUrl"
    private let attendeeIdStr = "attendeeId"
    private let joinTokenStr = "joinToken"
    private let meetingIdStr = "meetingId"
    private let turnControlUrl = "turnControlUrl"
    private let signalingUrl = "signalingUrl"

    func testMediaPlacementShouldBeInitialized() {
        let mediaPlacement = MediaPlacement(audioFallbackUrl: audioFallbackStr,
                                            audioHostUrl: audioHostStr,
                                            turnControlUrl: turnControlUrl,
                                            signalingUrl: signalingUrl)

        XCTAssertEqual(audioFallbackStr, mediaPlacement.audioFallbackUrl)
        XCTAssertEqual(audioHostStr, mediaPlacement.audioHostUrl)
    }

    func testMeetingShouldBeInitialized() {
        let mediaPlacement = MediaPlacement(audioFallbackUrl: audioFallbackStr,
                                            audioHostUrl: audioHostStr,
                                            turnControlUrl: turnControlUrl,
                                            signalingUrl: signalingUrl)
        let meeting = Meeting(meetingId: meetingIdStr, mediaPlacement: mediaPlacement)

        XCTAssertEqual(meetingIdStr, meeting.meetingId)
        XCTAssertEqual(mediaPlacement.audioFallbackUrl, meeting.mediaPlacement.audioFallbackUrl)
        XCTAssertEqual(mediaPlacement.audioHostUrl, meeting.mediaPlacement.audioHostUrl)
    }

    func testCreateMeetingResponseShouldBeInitialized() {
        let mediaPlacement = MediaPlacement(audioFallbackUrl: audioFallbackStr,
                                            audioHostUrl: audioHostStr,
                                            turnControlUrl: turnControlUrl,
                                            signalingUrl: signalingUrl)
        let meeting = Meeting(meetingId: meetingIdStr, mediaPlacement: mediaPlacement)
        let meetingResponse = CreateMeetingResponse(meeting: meeting)

        XCTAssertEqual(meeting.meetingId, meetingResponse.meeting.meetingId)
        XCTAssertEqual(meeting.mediaPlacement.audioFallbackUrl, meetingResponse.meeting.mediaPlacement.audioFallbackUrl)
        XCTAssertEqual(meeting.mediaPlacement.audioHostUrl, meetingResponse.meeting.mediaPlacement.audioHostUrl)
    }

    func testAttendeeShouldBeInitialized() {
        let attendee = Attendee(attendeeId: attendeeIdStr, joinToken: joinTokenStr)

        XCTAssertEqual(attendeeIdStr, attendee.attendeeId)
        XCTAssertEqual(joinTokenStr, attendee.joinToken)
    }

    func testCreateAttendeeResponseShouldBeInitialized() {
        let attendee = Attendee(attendeeId: attendeeIdStr, joinToken: joinTokenStr)
        let attendeeResponse = CreateAttendeeResponse(attendee: attendee)

        XCTAssertEqual(attendee.attendeeId, attendeeResponse.attendee.attendeeId)
        XCTAssertEqual(attendee.joinToken, attendeeResponse.attendee.joinToken)
    }

    func testMeetingSessionConfigurationShouldBeInitialized() {
        let mediaPlacement = MediaPlacement(audioFallbackUrl: audioFallbackStr,
                                            audioHostUrl: audioHostStr,
                                            turnControlUrl: turnControlUrl,
                                            signalingUrl: signalingUrl)
        let meeting = Meeting(meetingId: meetingIdStr, mediaPlacement: mediaPlacement)
        let meetingResponse = CreateMeetingResponse(meeting: meeting)
        let attendee = Attendee(attendeeId: attendeeIdStr, joinToken: joinTokenStr)
        let attendeeResponse = CreateAttendeeResponse(attendee: attendee)
        let configuration = MeetingSessionConfiguration(createMeetingResponse: meetingResponse,
                                                        createAttendeeResponse: attendeeResponse)

        XCTAssertEqual(meeting.meetingId, configuration.meetingId)
        XCTAssertEqual(mediaPlacement.audioFallbackUrl, configuration.urls.audioFallbackUrl)
        XCTAssertEqual(mediaPlacement.audioHostUrl, configuration.urls.audioHostUrl)
        XCTAssertEqual(attendee.attendeeId, configuration.credentials.attendeeId)
        XCTAssertEqual(attendee.joinToken, configuration.credentials.joinToken)
    }
}
