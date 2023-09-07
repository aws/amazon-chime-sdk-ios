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
            callKitEnabled: false,
            audioMode: .stereo48K,
            enableAudioRedundancy: true
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
            callKitEnabled: callKitEnabled,
            audioMode: .stereo48K,
            enableAudioRedundancy: true
        )).wasCalled()
        verify(videoClientControllerMock.start()).wasCalled()
    }

    func testStart_mono48K_callKitDisabled() {
        XCTAssertNoThrow(try defaultAudioVideoController.start(audioVideoConfiguration: AudioVideoConfiguration(audioMode: .mono48K, callKitEnabled: false)))

        verify(audioClientControllerMock.start(
            audioFallbackUrl: self.meetingSessionConfigurationMock.urls.audioFallbackUrl,
            audioHostUrl: self.meetingSessionConfigurationMock.urls.audioHostUrl,
            meetingId: self.meetingSessionConfigurationMock.meetingId,
            attendeeId: self.meetingSessionConfigurationMock.credentials.attendeeId,
            joinToken: self.meetingSessionConfigurationMock.credentials.joinToken,
            callKitEnabled: false,
            audioMode: .mono48K,
            enableAudioRedundancy: true
        )).wasCalled()
        verify(videoClientControllerMock.start()).wasCalled()
    }

    func testStart_mono48K_callKitEnabled() {
        XCTAssertNoThrow(try defaultAudioVideoController.start(audioVideoConfiguration: AudioVideoConfiguration(audioMode: .mono48K, callKitEnabled: true)))

        verify(audioClientControllerMock.start(
            audioFallbackUrl: self.meetingSessionConfigurationMock.urls.audioFallbackUrl,
            audioHostUrl: self.meetingSessionConfigurationMock.urls.audioHostUrl,
            meetingId: self.meetingSessionConfigurationMock.meetingId,
            attendeeId: self.meetingSessionConfigurationMock.credentials.attendeeId,
            joinToken: self.meetingSessionConfigurationMock.credentials.joinToken,
            callKitEnabled: true,
            audioMode: .mono48K,
            enableAudioRedundancy: true
        )).wasCalled()
        verify(videoClientControllerMock.start()).wasCalled()
    }

    func testStart_nodevice_callKitDisabled() {
        XCTAssertNoThrow(try defaultAudioVideoController.start(audioVideoConfiguration: AudioVideoConfiguration(audioMode: .nodevice, callKitEnabled: false)))

        verify(audioClientControllerMock.start(
            audioFallbackUrl: self.meetingSessionConfigurationMock.urls.audioFallbackUrl,
            audioHostUrl: self.meetingSessionConfigurationMock.urls.audioHostUrl,
            meetingId: self.meetingSessionConfigurationMock.meetingId,
            attendeeId: self.meetingSessionConfigurationMock.credentials.attendeeId,
            joinToken: self.meetingSessionConfigurationMock.credentials.joinToken,
            callKitEnabled: false,
            audioMode: .nodevice,
            enableAudioRedundancy: true
        )).wasCalled()
        verify(videoClientControllerMock.start()).wasCalled()
    }

    func testStart_nodevice_callKitEnabled() {
        XCTAssertNoThrow(try defaultAudioVideoController.start(audioVideoConfiguration: AudioVideoConfiguration(audioMode: .nodevice, callKitEnabled: true)))

        verify(audioClientControllerMock.start(
            audioFallbackUrl: self.meetingSessionConfigurationMock.urls.audioFallbackUrl,
            audioHostUrl: self.meetingSessionConfigurationMock.urls.audioHostUrl,
            meetingId: self.meetingSessionConfigurationMock.meetingId,
            attendeeId: self.meetingSessionConfigurationMock.credentials.attendeeId,
            joinToken: self.meetingSessionConfigurationMock.credentials.joinToken,
            callKitEnabled: true,
            audioMode: .nodevice,
            enableAudioRedundancy: true
        )).wasCalled()
        verify(videoClientControllerMock.start()).wasCalled()
    }

    func testStart_mono16K_callKitDisabled() {
        XCTAssertNoThrow(try defaultAudioVideoController.start(audioVideoConfiguration: AudioVideoConfiguration(audioMode: .mono16K, callKitEnabled: false)))

        verify(audioClientControllerMock.start(
            audioFallbackUrl: self.meetingSessionConfigurationMock.urls.audioFallbackUrl,
            audioHostUrl: self.meetingSessionConfigurationMock.urls.audioHostUrl,
            meetingId: self.meetingSessionConfigurationMock.meetingId,
            attendeeId: self.meetingSessionConfigurationMock.credentials.attendeeId,
            joinToken: self.meetingSessionConfigurationMock.credentials.joinToken,
            callKitEnabled: false,
            audioMode: .mono16K,
            enableAudioRedundancy: true
        )).wasCalled()
        verify(videoClientControllerMock.start()).wasCalled()
    }

    func testStart_mono16K_callKitEnabled() {
        XCTAssertNoThrow(try defaultAudioVideoController.start(audioVideoConfiguration: AudioVideoConfiguration(audioMode: .mono16K, callKitEnabled: true)))

        verify(audioClientControllerMock.start(
            audioFallbackUrl: self.meetingSessionConfigurationMock.urls.audioFallbackUrl,
            audioHostUrl: self.meetingSessionConfigurationMock.urls.audioHostUrl,
            meetingId: self.meetingSessionConfigurationMock.meetingId,
            attendeeId: self.meetingSessionConfigurationMock.credentials.attendeeId,
            joinToken: self.meetingSessionConfigurationMock.credentials.joinToken,
            callKitEnabled: true,
            audioMode: .mono16K,
            enableAudioRedundancy: true
        )).wasCalled()
        verify(videoClientControllerMock.start()).wasCalled()
    }

    func testStart_audioRedundancyDisabled() {
        XCTAssertNoThrow(try defaultAudioVideoController.start(audioVideoConfiguration: AudioVideoConfiguration(enableAudioRedundancy: false)))

        verify(audioClientControllerMock.start(
            audioFallbackUrl: self.meetingSessionConfigurationMock.urls.audioFallbackUrl,
            audioHostUrl: self.meetingSessionConfigurationMock.urls.audioHostUrl,
            meetingId: self.meetingSessionConfigurationMock.meetingId,
            attendeeId: self.meetingSessionConfigurationMock.credentials.attendeeId,
            joinToken: self.meetingSessionConfigurationMock.credentials.joinToken,
            callKitEnabled: false,
            audioMode: .stereo48K,
            enableAudioRedundancy: false
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

    func testStartLocalVideoWithConfig() {
        let config = LocalVideoConfiguration()
        XCTAssertNoThrow(try defaultAudioVideoController.startLocalVideo(config: config))

        verify(videoClientControllerMock.startLocalVideo(config: config)).wasCalled()
    }

    func testStartLocalVideoWithSource() {
        let cameraCaptureSourceMock: CameraCaptureSourceMock = mock(CameraCaptureSource.self)
        defaultAudioVideoController.startLocalVideo(source: cameraCaptureSourceMock)

        verify(videoClientControllerMock.startLocalVideo(source: cameraCaptureSourceMock)).wasCalled()
    }

    func testStartLocalVideoWithSourceAndConfig() {
        let config = LocalVideoConfiguration()
        let cameraCaptureSourceMock: CameraCaptureSourceMock = mock(CameraCaptureSource.self)
        defaultAudioVideoController.startLocalVideo(source: cameraCaptureSourceMock, config: config)

        verify(videoClientControllerMock.startLocalVideo(source: cameraCaptureSourceMock, config: config)).wasCalled()
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
