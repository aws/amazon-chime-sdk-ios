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

class DefaultAudioVideoControllerTests: CommonTestCase {
    var audioClientControllerMock: AudioClientControllerMock!
    var audioClientObserverMock: AudioClientObserverMock!
    var clientMetricsCollectorMock: ClientMetricsCollectorMock!
    var videoClientControllerMock: VideoClientControllerMock!
    var videoTileControllerMock: VideoTileControllerMock!
    var defaultAudioClientMock: DefaultAudioClientMock!
    var defaultAudioVideoController: DefaultAudioVideoController!

    override func setUp() {
        super.setUp()

        audioClientControllerMock = mock(AudioClientController.self)
        audioClientObserverMock = mock(AudioClientObserver.self)
        clientMetricsCollectorMock = mock(ClientMetricsCollector.self)
        videoClientControllerMock = mock(VideoClientController.self)
        videoTileControllerMock = mock(VideoTileController.self)

        defaultAudioVideoController = DefaultAudioVideoController(audioClientController: audioClientControllerMock,
                                                                  audioClientObserver: audioClientObserverMock,
                                                                  clientMetricsCollector: clientMetricsCollectorMock,
                                                                  videoClientController: videoClientControllerMock,
                                                                  videoTileController: videoTileControllerMock,
                                                                  configuration: meetingSessionConfigurationMock,
                                                                  logger: loggerMock)
    }

    func testStart() {
        XCTAssertNoThrow(try defaultAudioVideoController.start())

        verify(audioClientControllerMock.start(
            audioFallbackUrl: self.meetingSessionConfigurationMock.urls.audioFallbackUrl,
            audioHostUrl: self.meetingSessionConfigurationMock.urls.audioHostUrl,
            meetingId: self.meetingSessionConfigurationMock.meetingId,
            attendeeId: self.meetingSessionConfigurationMock.credentials.attendeeId,
            joinToken: self.meetingSessionConfigurationMock.credentials.joinToken,
            callKitEnabled: false
        )).wasCalled()
        verify(videoClientControllerMock.start()).wasCalled()
    }

    func testStart_callKitEnabled() {
        let callKitEnabled = true
        XCTAssertNoThrow(try defaultAudioVideoController.start(callKitEnabled: callKitEnabled))

        verify(audioClientControllerMock.start(
            audioFallbackUrl: self.meetingSessionConfigurationMock.urls.audioFallbackUrl,
            audioHostUrl: self.meetingSessionConfigurationMock.urls.audioHostUrl,
            meetingId: self.meetingSessionConfigurationMock.meetingId,
            attendeeId: self.meetingSessionConfigurationMock.credentials.attendeeId,
            joinToken: self.meetingSessionConfigurationMock.credentials.joinToken,
            callKitEnabled: callKitEnabled
        )).wasCalled()
        verify(videoClientControllerMock.start()).wasCalled()
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
        verify(videoClientControllerMock.subscribeToVideoClientStateChange(observer: audioVideoObserverMock))
            .wasCalled()
    }

    func testRemoveAudioVideoObserver() {
        let audioVideoObserverMock: AudioVideoObserverMock = mock(AudioVideoObserver.self)
        defaultAudioVideoController.removeAudioVideoObserver(observer: audioVideoObserverMock)

        verify(audioClientObserverMock.unsubscribeFromAudioClientStateChange(observer: audioVideoObserverMock))
            .wasCalled()
        verify(videoClientControllerMock.unsubscribeFromVideoClientStateChange(observer: audioVideoObserverMock))
            .wasCalled()
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
