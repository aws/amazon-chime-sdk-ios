//
//  DefaultAudioVideoFacadeTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Mockingbird
import XCTest

class DefaultAudioVideoFacadeTests: CommonTestCase {
    var audioVideoControllerMock: AudioVideoControllerFacadeMock!
    var realtimeControllerMock: RealtimeControllerFacadeMock!
    var deviceControllerMock: DeviceControllerMock!
    var videoTileControllerMock: VideoTileControllerMock!
    var activeSpeakerDetectorMock: ActiveSpeakerDetectorFacadeMock!
    var contentShareControllerMock: ContentShareControllerMock!
    var eventAnalyticsControllerMock: EventAnalyticsControllerMock!
    var meetingStatsCollectorMock: MeetingStatsCollectorMock!

    var defaultAudioVideoFacade: DefaultAudioVideoFacade!

    override func setUp() {
        super.setUp()

        audioVideoControllerMock = mock(AudioVideoControllerFacade.self)
        realtimeControllerMock = mock(RealtimeControllerFacade.self)
        deviceControllerMock = mock(DeviceController.self)
        videoTileControllerMock = mock(VideoTileController.self)
        activeSpeakerDetectorMock = mock(ActiveSpeakerDetectorFacade.self)
        contentShareControllerMock = mock(ContentShareController.self)
        eventAnalyticsControllerMock = mock(EventAnalyticsController.self)
        meetingStatsCollectorMock = mock(MeetingStatsCollector.self)

        var valueProvider = ValueProvider()
        valueProvider.register(loggerMock, for: Logger.self)
        valueProvider.register(meetingSessionConfigurationMock, for: MeetingSessionConfiguration.self)
        audioVideoControllerMock.useDefaultValues(from: valueProvider)

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
        given(audioVideoControllerMock.start(audioVideoConfiguration: any())).willReturn()

        XCTAssertNoThrow(try defaultAudioVideoFacade.start(audioVideoConfiguration: audioVideoConfiguration))

        verify(audioVideoControllerMock.start(audioVideoConfiguration: audioVideoConfiguration)).wasCalled()
    }

    func testStart_WithCallKitArgs() {
        given(audioVideoControllerMock.start(audioVideoConfiguration: any())).willReturn()

        XCTAssertNoThrow(try defaultAudioVideoFacade.start(callKitEnabled: true))

        verify(audioVideoControllerMock.start(audioVideoConfiguration: any(where: { $0.audioMode == .stereo48K && $0.callKitEnabled == true }))).wasCalled()
    }

    func testStart_WithNoArgs() {
        given(audioVideoControllerMock.start(audioVideoConfiguration: any())).willReturn()

        XCTAssertNoThrow(try defaultAudioVideoFacade.start())

        verify(audioVideoControllerMock.start(audioVideoConfiguration: any(where: { $0.audioMode == .stereo48K && $0.callKitEnabled == false }))).wasCalled()
    }
}
