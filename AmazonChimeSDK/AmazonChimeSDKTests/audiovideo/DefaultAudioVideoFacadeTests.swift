//
//  DefaultAudioVideoFacadeTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Cuckoo
import XCTest

class DefaultAudioVideoFacadeTests: CommonTestCase {
    var audioVideoControllerMock: MockAudioVideoControllerFacade!
    var realtimeControllerMock: MockRealtimeControllerFacade!
    var deviceControllerMock: MockDeviceController!
    var videoTileControllerMock: MockVideoTileController!
    var activeSpeakerDetectorMock: MockActiveSpeakerDetectorFacade!
    var contentShareControllerMock: MockContentShareController!
    var eventAnalyticsControllerMock: MockEventAnalyticsController!
    var meetingStatsCollectorMock: MockMeetingStatsCollector!

    var defaultAudioVideoFacade: DefaultAudioVideoFacade!

    override func setUp() {
        super.setUp()

        audioVideoControllerMock = MockAudioVideoControllerFacade().withEnabledDefaultImplementation(AudioVideoControllerFacadeStub())
        realtimeControllerMock = MockRealtimeControllerFacade().withEnabledDefaultImplementation(RealtimeControllerFacadeStub())
        deviceControllerMock = MockDeviceController().withEnabledDefaultImplementation(DeviceControllerStub())
        videoTileControllerMock = MockVideoTileController().withEnabledDefaultImplementation(VideoTileControllerStub())
        activeSpeakerDetectorMock = MockActiveSpeakerDetectorFacade().withEnabledDefaultImplementation(ActiveSpeakerDetectorFacadeStub())
        contentShareControllerMock = MockContentShareController().withEnabledDefaultImplementation(ContentShareControllerStub())
        eventAnalyticsControllerMock = MockEventAnalyticsController().withEnabledDefaultImplementation(EventAnalyticsControllerStub())
        meetingStatsCollectorMock = MockMeetingStatsCollector().withEnabledDefaultImplementation(MeetingStatsCollectorStub())

        stub(audioVideoControllerMock) { stub in
            when(stub.logger.get).thenReturn(loggerMock)
            when(stub.configuration.get).thenReturn(meetingSessionConfigurationMock)
        }

        defaultAudioVideoFacade = DefaultAudioVideoFacade(audioVideoController: audioVideoControllerMock,
                                                          realtimeController: realtimeControllerMock,
                                                          deviceController: deviceControllerMock,
                                                          videoTileController: videoTileControllerMock,
                                                          activeSpeakerDetector: activeSpeakerDetectorMock,
                                                          contentShareController: contentShareControllerMock,
                                                          eventAnalyticsController: eventAnalyticsControllerMock,
                                                          meetingStatsCollector: meetingStatsCollectorMock)
    }

    func testStart_WithConfigArgs() {
        let audioVideoConfiguration = AudioVideoConfiguration(audioMode: .mono48K, callKitEnabled: true)
        stub(audioVideoControllerMock) { stub in
            when(stub.start(audioVideoConfiguration: any())).thenDoNothing()
        }

        XCTAssertNoThrow(try defaultAudioVideoFacade.start(audioVideoConfiguration: audioVideoConfiguration))

        verify(audioVideoControllerMock).start(audioVideoConfiguration: equal(to: audioVideoConfiguration))
    }

    func testStart_WithCallKitArgs() {
        stub(audioVideoControllerMock) { stub in
            when(stub.start(audioVideoConfiguration: any())).thenDoNothing()
        }

        XCTAssertNoThrow(try defaultAudioVideoFacade.start(callKitEnabled: true))

        verify(audioVideoControllerMock).start(audioVideoConfiguration: ParameterMatcher { $0.audioMode == .stereo48K && $0.callKitEnabled == true })
    }

    func testStart_WithNoArgs() {
        stub(audioVideoControllerMock) { stub in
            when(stub.start(audioVideoConfiguration: any())).thenDoNothing()
        }

        XCTAssertNoThrow(try defaultAudioVideoFacade.start())

        verify(audioVideoControllerMock).start(audioVideoConfiguration: ParameterMatcher { $0.audioMode == .stereo48K && $0.callKitEnabled == false })
    }

    func testStartLocalVideo() {
        XCTAssertNoThrow(try defaultAudioVideoFacade.startLocalVideo())

        verify(audioVideoControllerMock).startLocalVideo()
    }

    func testStartLocalVideoWithConfig() {
        let config = LocalVideoConfiguration()
        XCTAssertNoThrow(try defaultAudioVideoFacade.startLocalVideo(config: config))

        verify(audioVideoControllerMock).startLocalVideo(config: equal(to: config))
    }

    func testStartLocalVideoWithSource() {
        let cameraCaptureSourceMock: MockCameraCaptureSource = MockCameraCaptureSource().withEnabledDefaultImplementation(CameraCaptureSourceStub())
        defaultAudioVideoFacade.startLocalVideo(source: cameraCaptureSourceMock)

        verify(audioVideoControllerMock).startLocalVideo(source: equal(to: cameraCaptureSourceMock))
    }

    func testStartLocalVideoWithSourceAndConfig() {
        let config = LocalVideoConfiguration()
        let cameraCaptureSourceMock: MockCameraCaptureSource = MockCameraCaptureSource().withEnabledDefaultImplementation(CameraCaptureSourceStub())
        defaultAudioVideoFacade.startLocalVideo(source: cameraCaptureSourceMock, config: config)

        verify(audioVideoControllerMock).startLocalVideo(source: equal(to: cameraCaptureSourceMock), config: equal(to: config))
    }

    func testRealtimePlaybackMute() {
        stub(realtimeControllerMock) { stub in
            when(stub.realtimePlaybackMute()).thenReturn(true)
        }

        let result = defaultAudioVideoFacade.realtimePlaybackMute()

        XCTAssertTrue(result)
        verify(realtimeControllerMock).realtimePlaybackMute()
    }

    func testRealtimePlaybackUnmute() {
        stub(realtimeControllerMock) { stub in
            when(stub.realtimePlaybackUnmute()).thenReturn(true)
        }

        let result = defaultAudioVideoFacade.realtimePlaybackUnmute()

        XCTAssertTrue(result)
        verify(realtimeControllerMock).realtimePlaybackUnmute()
    }

    func testStartContentShare() {
        let source = ContentShareSource()
        defaultAudioVideoFacade.startContentShare(source: source)

        verify(contentShareControllerMock).startContentShare(source: equal(to: source))
    }

    func testStartContentSharewithConfig() {
        let source = ContentShareSource()
        let config = LocalVideoConfiguration()
        defaultAudioVideoFacade.startContentShare(source: source, config: config)

        verify(contentShareControllerMock).startContentShare(source: equal(to: source), config: equal(to: config))
    }
}
