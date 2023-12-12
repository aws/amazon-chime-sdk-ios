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
    private var meetingSessionNone: DefaultMeetingSession?
    private var meetingSessionHigh: DefaultMeetingSession?

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

        // MaxResolution set to disabled
        let meetingNone = Meeting(externalMeetingId: externalMeetingIdStr,
                                  mediaPlacement: mediaPlacement,
                                  meetingFeatures: MeetingFeatures(video: "none", content: "none"),
                                  mediaRegion: mediaRegionStr,
                                  meetingId: meetingIdStr,
                                  primaryMeetingId: nil)
        let configurationNone = MeetingSessionConfiguration(
            createMeetingResponse: CreateMeetingResponse(meeting: meetingNone),
            createAttendeeResponse: CreateAttendeeResponse(attendee: attendee)
        )
        meetingSessionNone = DefaultMeetingSession(configuration: configurationNone, logger: logger)

        // MaxResolution set to high
        let meetingHigh = Meeting(externalMeetingId: externalMeetingIdStr,
                                  mediaPlacement: mediaPlacement,
                                  meetingFeatures: MeetingFeatures(video: "fhd", content: "uhd"),
                                  mediaRegion: mediaRegionStr,
                                  meetingId: meetingIdStr,
                                  primaryMeetingId: nil)
        let configurationHigh = MeetingSessionConfiguration(
            createMeetingResponse: CreateMeetingResponse(meeting: meetingHigh),
            createAttendeeResponse: CreateAttendeeResponse(attendee: attendee)
        )
        meetingSessionHigh = DefaultMeetingSession(configuration: configurationHigh, logger: logger)
    }

    func testMeetingSessionShouldBeInitialized() throws {
        XCTAssertNotNil(meetingSession)
        XCTAssertNotNil(meetingSession?.audioVideo)
    }

    func testDefaultMeetingFeaturesShouldBeInitializedThroughConstructor() {
        let localConfiguration = meetingSession?.configuration
        XCTAssertNil(localConfiguration!.urls.ingestionUrl)
        XCTAssertEqual(localConfiguration!.meetingFeatures.videoMaxResolution, VideoResolution.videoResolutionHD)
        XCTAssertEqual(localConfiguration!.meetingFeatures.contentMaxResolution, VideoResolution.videoResolutionFHD)
    }

    func testNoneMeetingFeaturesShouldBeInitializedThroughConstructor() {
        let localConfiguration = meetingSessionNone?.configuration
        XCTAssertNil(localConfiguration!.urls.ingestionUrl)
        XCTAssertEqual(localConfiguration!.meetingFeatures.videoMaxResolution, VideoResolution.videoDisabled)
        XCTAssertEqual(localConfiguration!.meetingFeatures.contentMaxResolution, VideoResolution.videoDisabled)
    }

    func testHighMeetingFeaturesShouldBeInitializedThroughConstructor() {
        let localConfiguration = meetingSessionHigh?.configuration
        XCTAssertNil(localConfiguration!.urls.ingestionUrl)
        XCTAssertEqual(localConfiguration!.meetingFeatures.videoMaxResolution, VideoResolution.videoResolutionFHD)
        XCTAssertEqual(localConfiguration!.meetingFeatures.contentMaxResolution, VideoResolution.videoResolutionUHD)
    }
}
