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
    let externalMeetingId = "external-meeting-id"
    let audioFallbackUrl = "audioFallbackUrl"
    let audioHostUrl = "audioHostUrl"
    let signalingUrl = "signalingUrl"
    let turnControlUrl = "turnControlUrl"
    let mediaRegion = "us-east-1"
    let meetingId = "meeting-id"
    let attendeeId = "attendee-id"
    let externalUserId = "externalUserId"
    let joinToken = "join-token"

    var meetingSessionConfigurationMock: MeetingSessionConfigurationMock!
    var loggerMock: LoggerMock!
    var audioClientControllerMock: AudioClientControllerMock!
    var audioClientObserverMock: AudioClientObserverMock!
    var clientMetricsCollectorMock: ClientMetricsCollectorMock!
    var videoClientControllerMock: VideoClientControllerMock!
    var defaultAudioClientMock: DefaultAudioClientMock!
    var defaultAudioVideoController: DefaultAudioVideoController!

    override func setUp() {
        let mediaPlacementMock: MediaPlacementMock = mock(MediaPlacement.self)
            .initialize(audioFallbackUrl: audioFallbackUrl,
                        audioHostUrl: audioHostUrl,
                        signalingUrl: signalingUrl,
                        turnControlUrl: turnControlUrl)
        let meetingMock: MeetingMock = mock(Meeting.self).initialize(externalMeetingId: externalMeetingId,
                                                                     mediaPlacement: mediaPlacementMock,
                                                                     mediaRegion: mediaRegion,
                                                                     meetingId: meetingId)
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

    func testStart() {
        XCTAssertNoThrow(try defaultAudioVideoController.start())
        
        verify(audioClientControllerMock.start(audioFallbackUrl: self.meetingSessionConfigurationMock.urls.audioFallbackUrl,
                                               audioHostUrl: self.meetingSessionConfigurationMock.urls.audioHostUrl,
                                               meetingId: self.meetingSessionConfigurationMock.meetingId,
                                               attendeeId: self.meetingSessionConfigurationMock.credentials.attendeeId,
                                               joinToken: self.meetingSessionConfigurationMock.credentials.joinToken,
                                               callKitEnabled: false)).wasCalled()
        verify(videoClientControllerMock.start(turnControlUrl: self.meetingSessionConfigurationMock.urls.turnControlUrl,
                                               signalingUrl: self.meetingSessionConfigurationMock.urls.signalingUrl,
                                               meetingId: self.meetingSessionConfigurationMock.meetingId,
                                               joinToken: self.meetingSessionConfigurationMock.credentials.joinToken)).wasCalled()
    }
    
    func testStart_callKitEnabled() {
        let callKitEnabled = true;
        XCTAssertNoThrow(try defaultAudioVideoController.start(callKitEnabled: callKitEnabled))
        
        verify(audioClientControllerMock.start(audioFallbackUrl: self.meetingSessionConfigurationMock.urls.audioFallbackUrl,
                                               audioHostUrl: self.meetingSessionConfigurationMock.urls.audioHostUrl,
                                               meetingId: self.meetingSessionConfigurationMock.meetingId,
                                               attendeeId: self.meetingSessionConfigurationMock.credentials.attendeeId,
                                               joinToken: self.meetingSessionConfigurationMock.credentials.joinToken,
                                               callKitEnabled: callKitEnabled)).wasCalled()
        verify(videoClientControllerMock.start(turnControlUrl: self.meetingSessionConfigurationMock.urls.turnControlUrl,
                                               signalingUrl: self.meetingSessionConfigurationMock.urls.signalingUrl,
                                               meetingId: self.meetingSessionConfigurationMock.meetingId,
                                               joinToken: self.meetingSessionConfigurationMock.credentials.joinToken)).wasCalled()
    }

    func testStop() {
        defaultAudioVideoController.stop()

        verify(audioClientControllerMock.stop()).wasCalled()
        verify(videoClientControllerMock.stopAndDestroy()).wasCalled()
    }
    
    func testAddAudioVideoObserver() {
        let audioVideoObserverMock: AudioVideoObserverMock = mock(AudioVideoObserver.self)
        defaultAudioVideoController.addAudioVideoObserver(observer: audioVideoObserverMock)

        verify(audioClientObserverMock.subscribeToAudioClientStateChange(observer: audioVideoObserverMock)).wasCalled()
        verify(videoClientControllerMock.subscribeToVideoClientStateChange(observer: audioVideoObserverMock)).wasCalled()
    }
    
    func testRemoveAudioVideoObserver() {
        let audioVideoObserverMock: AudioVideoObserverMock = mock(AudioVideoObserver.self)
        defaultAudioVideoController.removeAudioVideoObserver(observer: audioVideoObserverMock)
        
        verify(audioClientObserverMock.unsubscribeFromAudioClientStateChange(observer: audioVideoObserverMock)).wasCalled()
        verify(videoClientControllerMock.unsubscribeFromVideoClientStateChange(observer: audioVideoObserverMock)).wasCalled()
    }
    
    func testAddMetricsObserver() {
        let metricsObserverMock: MetricsObserverMock = mock(MetricsObserver.self)
        defaultAudioVideoController.addMetricsObserver(observer: metricsObserverMock)
        
        verify(clientMetricsCollectorMock.subscribeToMetrics(observer: metricsObserverMock)).wasCalled()
    }
    
    func testRemoveMetricsObserver() {
        let metricsObserverMock: MetricsObserverMock = mock(MetricsObserver.self)
        defaultAudioVideoController.removeMetricsObserver(observer: metricsObserverMock)
        
        verify(clientMetricsCollectorMock.unsubscribeFromMetrics(observer: metricsObserverMock)).wasCalled()
    }
    
    func testStartLocalVideo() {
        XCTAssertNoThrow(try defaultAudioVideoController.startLocalVideo())
        
        verify(videoClientControllerMock.startLocalVideo()).wasCalled()
    }
    
    func testStopLocalVideo() {
        defaultAudioVideoController.stopLocalVideo()
        
        verify(videoClientControllerMock.stopLocalVideo()).wasCalled()
    }
    
    func testStartRemoteVideo() {
        defaultAudioVideoController.startRemoteVideo()
        
        verify(videoClientControllerMock.startRemoteVideo()).wasCalled()
    }
    
    func testStopRemoteVideo() {
        defaultAudioVideoController.stopRemoteVideo()
        
        verify(videoClientControllerMock.stopRemoteVideo()).wasCalled()
    }
}
