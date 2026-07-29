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

    // NOTE: the Mockingbird version wrapped these data objects in
    // class mocks initialized with real values. No test ever stubs or verifies them
    // (they are pure value holders), so real instances are used here instead.
    var meetingSessionConfigurationMock: MeetingSessionConfiguration!
    var meetingSessionConfigurationMockNone: MeetingSessionConfiguration!
    var meetingSessionConfigurationMockHigh: MeetingSessionConfiguration!
    var eventClientConfig: EventClientConfiguration!
    var ingestionConfiguration: IngestionConfiguration!
    var loggerMock: LoggerSpy!

    override func setUp() {
        let mediaPlacement = MediaPlacement(audioFallbackUrl: audioFallbackUrl,
                                            audioHostUrl: audioHostUrlWithPort,
                                            signalingUrl: signalingUrl,
                                            turnControlUrl: turnControlUrl, eventIngestionUrl: nil)
        let meetingFeatures = MeetingFeatures(videoMaxResolution: VideoResolution.videoResolutionHD,
                                              contentMaxResolution: VideoResolution.videoResolutionFHD)
        let meeting = Meeting(externalMeetingId: externalMeetingId,
                              mediaPlacement: mediaPlacement,
                              meetingFeatures: meetingFeatures,
                              mediaRegion: mediaRegion,
                              meetingId: meetingId,
                              primaryMeetingId: nil)
        let createMeetingResponse = CreateMeetingResponse(meeting: meeting)

        let attendee = Attendee(attendeeId: attendeeId,
                                externalUserId: externalUserId,
                                joinToken: joinToken)
        let createAttendeeResponse = CreateAttendeeResponse(attendee: attendee)
        meetingSessionConfigurationMock = MeetingSessionConfiguration(createMeetingResponse: createMeetingResponse,
                                                                      createAttendeeResponse: createAttendeeResponse,
                                                                      urlRewriter: URLRewriterUtils.defaultUrlRewriter)

        // Meeting features with MaxResolution set to Disabled
        let meetingFeaturesNone = MeetingFeatures(videoMaxResolution: VideoResolution.videoDisabled,
                                                  contentMaxResolution: VideoResolution.videoDisabled)
        let meetingNone = Meeting(externalMeetingId: externalMeetingId,
                                  mediaPlacement: mediaPlacement,
                                  meetingFeatures: meetingFeaturesNone,
                                  mediaRegion: mediaRegion,
                                  meetingId: meetingId,
                                  primaryMeetingId: nil)
        let createMeetingResponseNone = CreateMeetingResponse(meeting: meetingNone)
        meetingSessionConfigurationMockNone = MeetingSessionConfiguration(createMeetingResponse: createMeetingResponseNone,
                                                                          createAttendeeResponse: createAttendeeResponse,
                                                                          urlRewriter: URLRewriterUtils.defaultUrlRewriter)

        // Meeting features with MaxResolution set to High
        let meetingFeaturesHigh = MeetingFeatures(videoMaxResolution: VideoResolution.videoResolutionFHD,
                                                  contentMaxResolution: VideoResolution.videoResolutionUHD)
        let meetingHigh = Meeting(externalMeetingId: externalMeetingId,
                                  mediaPlacement: mediaPlacement,
                                  meetingFeatures: meetingFeaturesHigh,
                                  mediaRegion: mediaRegion,
                                  meetingId: meetingId,
                                  primaryMeetingId: nil)
        let createMeetingResponseHigh = CreateMeetingResponse(meeting: meetingHigh)
        meetingSessionConfigurationMockHigh = MeetingSessionConfiguration(createMeetingResponse: createMeetingResponseHigh,
                                                                          createAttendeeResponse: createAttendeeResponse,
                                                                          urlRewriter: URLRewriterUtils.defaultUrlRewriter)

        loggerMock = LoggerSpy()
        loggerMock.logLevelReturn = .INFO

        eventClientConfig = MeetingEventClientConfiguration(eventClientJoinToken: "testJoinToken",
                                                            meetingId: "testMeetingId",
                                                            attendeeId: "testAttendeeId")

        ingestionConfiguration = IngestionConfigurationBuilder().build(disabled: false,
                                                                       ingestionUrl: "testIngestionUrl",
                                                                       clientConiguration: eventClientConfig)
    }
}
