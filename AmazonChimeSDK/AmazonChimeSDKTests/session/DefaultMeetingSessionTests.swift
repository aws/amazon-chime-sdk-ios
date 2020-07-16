//
//  DefaultMeetingSessionTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class DefaultMeetingSessionTests: XCTestCase {
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

    private var meetingSession: DefaultMeetingSession?

    override func setUp() {
        super.setUp()
        let mediaPlacement = MediaPlacement(audioFallbackUrl: audioFallbackStr,
                                            audioHostUrl: audioHostStr,
                                            signalingUrl: signalingUrlStr,
                                            turnControlUrl: turnControlUrlStr)
        let meeting = Meeting(externalMeetingId: externalMeetingIdStr,
                              mediaPlacement: mediaPlacement,
                              mediaRegion: mediaRegionStr,
                              meetingId: meetingIdStr)
        let attendee = Attendee(attendeeId: attendeeIdStr, externalUserId: externalUserIdStr, joinToken: joinTokenStr)
        let configuration = MeetingSessionConfiguration(
            createMeetingResponse: CreateMeetingResponse(meeting: meeting),
            createAttendeeResponse: CreateAttendeeResponse(attendee: attendee)
        )
        let logger = ConsoleLogger(name: "test")
        meetingSession = DefaultMeetingSession(configuration: configuration, logger: logger)
    }

    func testMeetingSessionShouldBeInitialized() throws {
        XCTAssertNotNil(meetingSession)
        XCTAssertNotNil(meetingSession?.audioVideo)
    }
}
