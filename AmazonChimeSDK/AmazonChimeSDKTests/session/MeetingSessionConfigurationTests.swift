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
    private let externalMeetingIdStr = "externalMeetingId"
    private let externalUserIdStr = "externalUserId"
    private let joinTokenStr = "joinToken"
    private let mediaRegionStr = "mediaRegion"
    private let meetingIdStr = "meetingId"
    private let signalingUrlStr = "signalingUrl"
    private let turnControlUrlStr = "turnControlUrl"

    func testMediaPlacementShouldBeInitialized() {
        let mediaPlacement = MediaPlacement(audioFallbackUrl: audioFallbackStr,
                                            audioHostUrl: audioHostStr,
                                            signalingUrl: signalingUrlStr,
                                            turnControlUrl: turnControlUrlStr)

        XCTAssertEqual(audioFallbackStr, mediaPlacement.audioFallbackUrl)
        XCTAssertEqual(audioHostStr, mediaPlacement.audioHostUrl)
        XCTAssertEqual(signalingUrlStr, mediaPlacement.signalingUrl)
        XCTAssertEqual(turnControlUrlStr, mediaPlacement.turnControlUrl)
    }

    func testMeetingShouldBeInitialized() {
        let mediaPlacement = MediaPlacement(audioFallbackUrl: audioFallbackStr,
                                            audioHostUrl: audioHostStr,
                                            signalingUrl: signalingUrlStr,
                                            turnControlUrl: turnControlUrlStr)
        let meeting = Meeting(externalMeetingId: externalMeetingIdStr,
                              mediaPlacement: mediaPlacement,
                              mediaRegion: mediaRegionStr,
                              meetingId: meetingIdStr)

        XCTAssertEqual(externalMeetingIdStr, meeting.externalMeetingId)
        XCTAssertEqual(mediaPlacement.audioFallbackUrl, meeting.mediaPlacement.audioFallbackUrl)
        XCTAssertEqual(mediaPlacement.audioHostUrl, meeting.mediaPlacement.audioHostUrl)
        XCTAssertEqual(mediaPlacement.signalingUrl, meeting.mediaPlacement.signalingUrl)
        XCTAssertEqual(mediaPlacement.turnControlUrl, meeting.mediaPlacement.turnControlUrl)
        XCTAssertEqual(mediaRegionStr, meeting.mediaRegion)
        XCTAssertEqual(meetingIdStr, meeting.meetingId)
    }

    func testCreateMeetingResponseShouldBeInitialized() {
        let mediaPlacement = MediaPlacement(audioFallbackUrl: audioFallbackStr,
                                            audioHostUrl: audioHostStr,
                                            signalingUrl: signalingUrlStr,
                                            turnControlUrl: turnControlUrlStr)
        let meeting = Meeting(externalMeetingId: externalMeetingIdStr,
                              mediaPlacement: mediaPlacement,
                              mediaRegion: mediaRegionStr,
                              meetingId: meetingIdStr)
        let meetingResponse = CreateMeetingResponse(meeting: meeting)

        XCTAssertEqual(meetingResponse.meeting.externalMeetingId, meeting.externalMeetingId)
        XCTAssertEqual(meetingResponse.meeting.mediaPlacement.audioFallbackUrl, meeting.mediaPlacement.audioFallbackUrl)
        XCTAssertEqual(meetingResponse.meeting.mediaPlacement.audioHostUrl, meeting.mediaPlacement.audioHostUrl)
        XCTAssertEqual(meetingResponse.meeting.mediaPlacement.signalingUrl, meeting.mediaPlacement.signalingUrl)
        XCTAssertEqual(meetingResponse.meeting.mediaPlacement.turnControlUrl, meeting.mediaPlacement.turnControlUrl)
        XCTAssertEqual(meetingResponse.meeting.mediaRegion, meeting.mediaRegion)
        XCTAssertEqual(meetingResponse.meeting.meetingId, meeting.meetingId)
    }

    func testAttendeeShouldBeInitialized() {
        let attendee = Attendee(attendeeId: attendeeIdStr, externalUserId: externalUserIdStr, joinToken: joinTokenStr)

        XCTAssertEqual(attendeeIdStr, attendee.attendeeId)
        XCTAssertEqual(externalUserIdStr, attendee.externalUserId)
        XCTAssertEqual(joinTokenStr, attendee.joinToken)
    }

    func testCreateAttendeeResponseShouldBeInitialized() {
        let attendee = Attendee(attendeeId: attendeeIdStr, externalUserId: externalUserIdStr, joinToken: joinTokenStr)
        let attendeeResponse = CreateAttendeeResponse(attendee: attendee)

        XCTAssertEqual(attendee.attendeeId, attendeeResponse.attendee.attendeeId)
        XCTAssertEqual(attendee.externalUserId, attendeeResponse.attendee.externalUserId)
        XCTAssertEqual(attendee.joinToken, attendeeResponse.attendee.joinToken)
    }

    func testMeetingSessionConfigurationShouldBeInitialized() {
        let mediaPlacement = MediaPlacement(audioFallbackUrl: audioFallbackStr,
                                            audioHostUrl: audioHostStr,
                                            signalingUrl: signalingUrlStr,
                                            turnControlUrl: turnControlUrlStr)
        let meeting = Meeting(externalMeetingId: externalMeetingIdStr,
                              mediaPlacement: mediaPlacement,
                              mediaRegion: mediaRegionStr,
                              meetingId: meetingIdStr)
        let meetingResponse = CreateMeetingResponse(meeting: meeting)
        let attendee = Attendee(attendeeId: attendeeIdStr, externalUserId: externalUserIdStr, joinToken: joinTokenStr)
        let attendeeResponse = CreateAttendeeResponse(attendee: attendee)
        let configuration = MeetingSessionConfiguration(createMeetingResponse: meetingResponse,
                                                        createAttendeeResponse: attendeeResponse)

        XCTAssertEqual(mediaPlacement.audioFallbackUrl, configuration.urls.audioFallbackUrl)
        XCTAssertEqual(mediaPlacement.audioHostUrl, configuration.urls.audioHostUrl)
        XCTAssertEqual(mediaPlacement.signalingUrl, configuration.urls.signalingUrl)
        XCTAssertEqual(mediaPlacement.turnControlUrl, configuration.urls.turnControlUrl)
        XCTAssertEqual(meeting.meetingId, configuration.meetingId)
        XCTAssertEqual(attendee.attendeeId, configuration.credentials.attendeeId)
        XCTAssertEqual(attendee.joinToken, configuration.credentials.joinToken)
    }
}
