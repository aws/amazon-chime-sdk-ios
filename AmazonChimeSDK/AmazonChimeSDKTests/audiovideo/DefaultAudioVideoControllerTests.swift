//
//  DefaultAudioVideoControllerTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import AVFoundation
import Mockingbird
import XCTest

class DefaultAudioVideoControllerTests: XCTestCase {
    var meetingSessionConfigurationMock: MeetingSessionConfigurationMock!
    var loggerMock: LoggerMock!
    var audioClientControllerMock: AudioClientControllerMock!
    var audioClientObserverMock: AudioClientObserverMock!
    var clientMetricsCollectorMock: ClientMetricsCollectorMock!
    var videoClientControllerMock: VideoClientControllerMock!
    var defaultAudioClientMock: DefaultAudioClientMock!
    var defaultAudioVideoController: DefaultAudioVideoController!

    override func setUp() {
        let externalMeetingId = "external-meeting-id"
        let audioFallbackUrl = "audioFallbackUrl"
        let audioHostUrl = "audioHostUrl"
        let signalingUrl = "signalingUrl"
        let turnControlUrl = "turnControlUrl"
        let mediaPlacementMock: MediaPlacementMock = mock(MediaPlacement.self)
            .initialize(audioFallbackUrl: audioFallbackUrl,
                        audioHostUrl: audioHostUrl,
                        signalingUrl: signalingUrl,
                        turnControlUrl: turnControlUrl)
        let mediaRegion = "us-east-1"
        let meetingId = "meeting-id"
        let meetingMock: MeetingMock = mock(Meeting.self).initialize(externalMeetingId: externalMeetingId,
                                                                     mediaPlacement: mediaPlacementMock,
                                                                     mediaRegion: mediaRegion,
                                                                     meetingId: meetingId)
        let createMeetingResponseMock: CreateMeetingResponseMock = mock(CreateMeetingResponse.self)
            .initialize(meeting: meetingMock)

        let attendeeId = "attendee-id"
        let externalUserId = "externalUserId"
        let joinToken = "join-token"
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
        audioClientControllerMock = mock(AudioClientController.self)
        audioClientObserverMock = mock(AudioClientObserver.self)
        clientMetricsCollectorMock = mock(ClientMetricsCollector.self)
        videoClientControllerMock = mock(VideoClientController.self)

        defaultAudioVideoController = DefaultAudioVideoController(audioClientController: audioClientControllerMock,
                                                                  audioClientObserver: audioClientObserverMock,
                                                                  clientMetricsCollector: clientMetricsCollectorMock,
                                                                  videoClientController: videoClientControllerMock,
                                                                  configuration: meetingSessionConfigurationMock,
                                                                  logger: loggerMock)
    }

//    func testStart_callKitEnabled() {
//        given(defaultAudioVideoController.getRecordPermission()).willReturn(AVAudioSession.RecordPermission.granted)
//    }
}
