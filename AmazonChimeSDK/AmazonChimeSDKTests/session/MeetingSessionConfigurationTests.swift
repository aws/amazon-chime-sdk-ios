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
    private let ingestionUrlStr = "ingestionUrl"

    private var mediaPlacement: MediaPlacement?
    private var meeting: Meeting?
    private var meetingResponse: CreateMeetingResponse?
    private var attendee: Attendee?
    private var attendeeResponse: CreateAttendeeResponse?
    private var configuration: MeetingSessionConfiguration?

    override func setUp() {
        super.setUp()
        mediaPlacement = MediaPlacement(audioFallbackUrl: audioFallbackStr,
                                        audioHostUrl: audioHostStr,
                                        signalingUrl: signalingUrlStr,
                                        turnControlUrl: turnControlUrlStr,
                                        eventIngestionUrl: ingestionUrlStr)
        if let mediaPlacement = mediaPlacement {
            meeting = Meeting(externalMeetingId: externalMeetingIdStr,
                              mediaPlacement: mediaPlacement,
                              mediaRegion: mediaRegionStr,
                              meetingId: meetingIdStr)
        }

        if let meeting = meeting {
            meetingResponse = CreateMeetingResponse(meeting: meeting)
        }

        attendee = Attendee(attendeeId: attendeeIdStr, externalUserId: externalUserIdStr, joinToken: joinTokenStr)

        if let attendee = attendee {
            attendeeResponse = CreateAttendeeResponse(attendee: attendee)
        }

        if let meetingResponse = meetingResponse, let attendeeResponse = attendeeResponse {
            configuration = MeetingSessionConfiguration(createMeetingResponse: meetingResponse,
                                                        createAttendeeResponse: attendeeResponse)
        }
    }

    func testExternalMeetingIdNilfNotProvidedThroughMeeting() {
        if let mediaPlacement = mediaPlacement, let attendeeResponse = attendeeResponse {
            let localMeeting = Meeting(externalMeetingId: nil,
                              mediaPlacement: mediaPlacement,
                              mediaRegion: mediaRegionStr,
                              meetingId: meetingIdStr)
            let localMeetingResponse = CreateMeetingResponse(meeting: localMeeting)
            let localConfiguration = MeetingSessionConfiguration(createMeetingResponse: localMeetingResponse,
                                                        createAttendeeResponse: attendeeResponse)
            XCTAssertNil(localConfiguration.externalMeetingId)
            return
        }

        XCTFail("Unable retrieve non null mediaPlacement or attendeeResponse")
    }

    let defaultUrlRewriter: URLRewriter = { url in
        url
    }

    func testExternalMeetingIdNilfNotProvidedThroughConstructor() {
        let credentials = MeetingSessionCredentials(attendeeId: attendeeIdStr,
                                                     externalUserId: externalUserIdStr,
                                                     joinToken: joinTokenStr)
        let urls = MeetingSessionURLs(audioFallbackUrl: audioFallbackStr,
                                       audioHostUrl: audioHostStr,
                                       turnControlUrl: turnControlUrlStr,
                                       signalingUrl: signalingUrlStr,
                                       urlRewriter: defaultUrlRewriter)

        let localConfiguration = MeetingSessionConfiguration(meetingId: meetingIdStr,
                                                             credentials: credentials,
                                                             urls: urls,
                                                             urlRewriter: defaultUrlRewriter)

        XCTAssertNil(localConfiguration.externalMeetingId)
    }

    func testIngestionUrlNilfNotProvidedThroughConstructor() {
        let credentials = MeetingSessionCredentials(attendeeId: attendeeIdStr,
                                                     externalUserId: externalUserIdStr,
                                                     joinToken: joinTokenStr)
        let urls = MeetingSessionURLs(audioFallbackUrl: audioFallbackStr,
                                       audioHostUrl: audioHostStr,
                                       turnControlUrl: turnControlUrlStr,
                                       signalingUrl: signalingUrlStr,
                                       urlRewriter: defaultUrlRewriter)

        let localConfiguration = MeetingSessionConfiguration(meetingId: meetingIdStr,
                                                             credentials: credentials,
                                                             urls: urls,
                                                             urlRewriter: defaultUrlRewriter)

        XCTAssertNil(localConfiguration.urls.ingestionUrl)
    }

    func testMediaPlacementShouldBeInitialized() {
        XCTAssertEqual(audioFallbackStr, mediaPlacement?.audioFallbackUrl)
        XCTAssertEqual(audioHostStr, mediaPlacement?.audioHostUrl)
        XCTAssertEqual(signalingUrlStr, mediaPlacement?.signalingUrl)
        XCTAssertEqual(turnControlUrlStr, mediaPlacement?.turnControlUrl)
    }

    func testMeetingShouldBeInitialized() {
        XCTAssertEqual(externalMeetingIdStr, meeting?.externalMeetingId)
        XCTAssertEqual(mediaPlacement?.audioFallbackUrl, meeting?.mediaPlacement.audioFallbackUrl)
        XCTAssertEqual(mediaPlacement?.audioHostUrl, meeting?.mediaPlacement.audioHostUrl)
        XCTAssertEqual(mediaPlacement?.signalingUrl, meeting?.mediaPlacement.signalingUrl)
        XCTAssertEqual(mediaPlacement?.turnControlUrl, meeting?.mediaPlacement.turnControlUrl)
        XCTAssertEqual(mediaRegionStr, meeting?.mediaRegion)
        XCTAssertEqual(meetingIdStr, meeting?.meetingId)
    }

    func testCreateMeetingResponseShouldBeInitialized() {
        XCTAssertEqual(meetingResponse?.meeting.externalMeetingId, meeting?.externalMeetingId)
        XCTAssertEqual(meetingResponse?.meeting.mediaPlacement.audioFallbackUrl,
                       meeting?.mediaPlacement.audioFallbackUrl)
        XCTAssertEqual(meetingResponse?.meeting.mediaPlacement.audioHostUrl, meeting?.mediaPlacement.audioHostUrl)
        XCTAssertEqual(meetingResponse?.meeting.mediaPlacement.signalingUrl, meeting?.mediaPlacement.signalingUrl)
        XCTAssertEqual(meetingResponse?.meeting.mediaPlacement.turnControlUrl, meeting?.mediaPlacement.turnControlUrl)
        XCTAssertEqual(meetingResponse?.meeting.mediaRegion, meeting?.mediaRegion)
        XCTAssertEqual(meetingResponse?.meeting.meetingId, meeting?.meetingId)
    }

    func testAttendeeShouldBeInitialized() {
        XCTAssertEqual(attendeeIdStr, attendee?.attendeeId)
        XCTAssertEqual(externalUserIdStr, attendee?.externalUserId)
        XCTAssertEqual(joinTokenStr, attendee?.joinToken)
    }

    func testCreateAttendeeResponseShouldBeInitialized() {
        XCTAssertEqual(attendee?.attendeeId, attendeeResponse?.attendee.attendeeId)
        XCTAssertEqual(attendee?.externalUserId, attendeeResponse?.attendee.externalUserId)
        XCTAssertEqual(attendee?.joinToken, attendeeResponse?.attendee.joinToken)
    }

    func testMeetingSessionConfigurationShouldBeInitialized() {
        XCTAssertEqual(mediaPlacement?.audioFallbackUrl, configuration?.urls.audioFallbackUrl)
        XCTAssertEqual(mediaPlacement?.audioHostUrl, configuration?.urls.audioHostUrl)
        XCTAssertEqual(mediaPlacement?.signalingUrl, configuration?.urls.signalingUrl)
        XCTAssertEqual(mediaPlacement?.turnControlUrl, configuration?.urls.turnControlUrl)
        XCTAssertEqual(meeting?.meetingId, configuration?.meetingId)
        XCTAssertEqual(attendee?.attendeeId, configuration?.credentials.attendeeId)
        XCTAssertEqual(attendee?.joinToken, configuration?.credentials.joinToken)
    }
}
