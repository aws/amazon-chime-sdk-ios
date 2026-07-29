//
//  DefaultAudioVideoFacadeTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class DefaultAudioVideoFacadeTests: CommonTestCase {
    var audioVideoControllerMock: AudioVideoControllerFacadeSpy!
    var realtimeControllerMock: RealtimeControllerFacadeSpy!
    var deviceControllerMock: DeviceControllerSpy!
    var videoTileControllerMock: VideoTileControllerSpy!
    var activeSpeakerDetectorMock: ActiveSpeakerDetectorFacadeSpy!
    var contentShareControllerMock: ContentShareControllerSpy!
    var eventAnalyticsControllerMock: EventAnalyticsControllerSpy!
    var meetingStatsCollectorMock: MeetingStatsCollectorSpy!

    var defaultAudioVideoFacade: DefaultAudioVideoFacade!

    override func setUp() {
        super.setUp()

        audioVideoControllerMock = AudioVideoControllerFacadeSpy(configuration: meetingSessionConfigurationMock,
                                                                logger: loggerMock)
        realtimeControllerMock = RealtimeControllerFacadeSpy()
        deviceControllerMock = DeviceControllerSpy()
        videoTileControllerMock = VideoTileControllerSpy()
        activeSpeakerDetectorMock = ActiveSpeakerDetectorFacadeSpy()
        contentShareControllerMock = ContentShareControllerSpy()
        eventAnalyticsControllerMock = EventAnalyticsControllerSpy()
        meetingStatsCollectorMock = MeetingStatsCollectorSpy()



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


        XCTAssertNoThrow(try defaultAudioVideoFacade.start(audioVideoConfiguration: audioVideoConfiguration))

        XCTAssertEqual(audioVideoControllerMock.startWithConfigurationCalls.filter { $0 === audioVideoConfiguration }.count, 1)
    }

    func testStart_WithCallKitArgs() {


        XCTAssertNoThrow(try defaultAudioVideoFacade.start(callKitEnabled: true))

        XCTAssertEqual(audioVideoControllerMock.startWithConfigurationCalls.filter { $0.audioMode == .stereo48K && $0.callKitEnabled == true }.count, 1)
    }

    func testStart_WithNoArgs() {


        XCTAssertNoThrow(try defaultAudioVideoFacade.start())

        XCTAssertEqual(audioVideoControllerMock.startWithConfigurationCalls.filter { $0.audioMode == .stereo48K && $0.callKitEnabled == false }.count, 1)
    }

    func testStartLocalVideo() {
        XCTAssertNoThrow(try defaultAudioVideoFacade.startLocalVideo())

        XCTAssertEqual(audioVideoControllerMock.startLocalVideoCalls.filter { $0.source == nil && $0.config == nil }.count, 1)
    }

    func testStartLocalVideoWithConfig() {
        let config = LocalVideoConfiguration()
        XCTAssertNoThrow(try defaultAudioVideoFacade.startLocalVideo(config: config))

        XCTAssertEqual(audioVideoControllerMock.startLocalVideoCalls.filter { $0.source == nil && $0.config === config }.count, 1)
    }

    func testStartLocalVideoWithSource() {
        let cameraCaptureSourceMock = CameraCaptureSourceSpy()
        defaultAudioVideoFacade.startLocalVideo(source: cameraCaptureSourceMock)

        XCTAssertEqual(audioVideoControllerMock.startLocalVideoCalls.filter { $0.source === cameraCaptureSourceMock && $0.config == nil }.count, 1)
    }

    func testStartLocalVideoWithSourceAndConfig() {
        let config = LocalVideoConfiguration()
        let cameraCaptureSourceMock = CameraCaptureSourceSpy()
        defaultAudioVideoFacade.startLocalVideo(source: cameraCaptureSourceMock, config: config)

        XCTAssertEqual(audioVideoControllerMock.startLocalVideoCalls.filter { $0.source === cameraCaptureSourceMock && $0.config === config }.count, 1)
    }

    func testRealtimePlaybackMute() {
        realtimeControllerMock.realtimePlaybackMuteReturn = true

        let result = defaultAudioVideoFacade.realtimePlaybackMute()

        XCTAssertTrue(result)
        XCTAssertEqual(realtimeControllerMock.realtimePlaybackMuteCallCount, 1)
    }

    func testRealtimePlaybackUnmute() {
        realtimeControllerMock.realtimePlaybackUnmuteReturn = true

        let result = defaultAudioVideoFacade.realtimePlaybackUnmute()

        XCTAssertTrue(result)
        XCTAssertEqual(realtimeControllerMock.realtimePlaybackUnmuteCallCount, 1)
    }

    func testStartContentShare() {
        let source = ContentShareSource()
        defaultAudioVideoFacade.startContentShare(source: source)

        XCTAssertEqual(contentShareControllerMock.startContentShareCalls.filter { $0.source === source && $0.config == nil }.count, 1)
    }

    func testStartContentSharewithConfig() {
        let source = ContentShareSource()
        let config = LocalVideoConfiguration()
        defaultAudioVideoFacade.startContentShare(source: source, config: config)

        XCTAssertEqual(contentShareControllerMock.startContentShareCalls.filter { $0.source === source && $0.config === config }.count, 1)
    }
}
