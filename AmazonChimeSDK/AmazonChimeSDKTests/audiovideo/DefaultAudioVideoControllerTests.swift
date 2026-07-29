//
//  DefaultAudioVideoControllerTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import AVFoundation
import Cuckoo
import XCTest

class DefaultAudioVideoControllerTests: CommonTestCase {
    private let reconnectTimeoutMs = 180 * 1000
    
    var audioClientControllerMock: MockAudioClientController!
    var audioClientObserverMock: MockAudioClientObserver!
    var clientMetricsCollectorMock: MockClientMetricsCollector!
    var videoClientControllerMock: MockVideoClientController!
    var videoTileControllerMock: MockVideoTileController!
    var appStateMonitorMock: MockAppStateMonitor!
    var defaultAudioVideoController: DefaultAudioVideoController!

    override func setUp() {
        super.setUp()

        audioClientControllerMock = MockAudioClientController().withEnabledDefaultImplementation(AudioClientControllerStub())
        audioClientObserverMock = MockAudioClientObserver().withEnabledDefaultImplementation(AudioClientObserverStub())
        clientMetricsCollectorMock = MockClientMetricsCollector().withEnabledDefaultImplementation(ClientMetricsCollectorStub())
        videoClientControllerMock = MockVideoClientController().withEnabledDefaultImplementation(VideoClientControllerStub())
        videoTileControllerMock = MockVideoTileController().withEnabledDefaultImplementation(VideoTileControllerStub())
        appStateMonitorMock = MockAppStateMonitor().withEnabledDefaultImplementation(AppStateMonitorStub())

        defaultAudioVideoController = DefaultAudioVideoController(audioClientController: audioClientControllerMock,
                                                                  audioClientObserver: audioClientObserverMock,
                                                                  clientMetricsCollector: clientMetricsCollectorMock,
                                                                  videoClientController: videoClientControllerMock,
                                                                  videoTileController: videoTileControllerMock,
                                                                  appStateMonitor: appStateMonitorMock,
                                                                  configuration: meetingSessionConfigurationMock,
                                                                  logger: loggerMock)
    }

    func testStart() {
        XCTAssertNoThrow(try defaultAudioVideoController.start())

        verify(audioClientControllerMock).start(
            audioFallbackUrl: self.meetingSessionConfigurationMock.urls.audioFallbackUrl,
            audioHostUrl: self.meetingSessionConfigurationMock.urls.audioHostUrl,
            meetingId: self.meetingSessionConfigurationMock.meetingId,
            attendeeId: self.meetingSessionConfigurationMock.credentials.attendeeId,
            joinToken: self.meetingSessionConfigurationMock.credentials.joinToken,
            callKitEnabled: false,
            audioMode: equal(to: AudioMode.stereo48K),
            audioDeviceCapabilities: equal(to: AudioDeviceCapabilities.inputAndOutput),
            enableAudioRedundancy: true,
            reconnectTimeoutMs: self.reconnectTimeoutMs
        )
        verify(videoClientControllerMock).start()
        verify(appStateMonitorMock).start()
    }

    func testStart_callKitEnabled() {
        let callKitEnabled = true
        XCTAssertNoThrow(try defaultAudioVideoController.start(callKitEnabled: callKitEnabled))

        verify(audioClientControllerMock).start(
            audioFallbackUrl: self.meetingSessionConfigurationMock.urls.audioFallbackUrl,
            audioHostUrl: self.meetingSessionConfigurationMock.urls.audioHostUrl,
            meetingId: self.meetingSessionConfigurationMock.meetingId,
            attendeeId: self.meetingSessionConfigurationMock.credentials.attendeeId,
            joinToken: self.meetingSessionConfigurationMock.credentials.joinToken,
            callKitEnabled: callKitEnabled,
            audioMode: equal(to: AudioMode.stereo48K),
            audioDeviceCapabilities: equal(to: AudioDeviceCapabilities.inputAndOutput),
            enableAudioRedundancy: true,
            reconnectTimeoutMs: self.reconnectTimeoutMs
        )
        verify(videoClientControllerMock).start()
    }

    func testStart_mono48K_callKitDisabled() {
        XCTAssertNoThrow(try defaultAudioVideoController.start(audioVideoConfiguration: AudioVideoConfiguration(audioMode: AudioMode.mono48K, callKitEnabled: false)))

        verify(audioClientControllerMock).start(
            audioFallbackUrl: self.meetingSessionConfigurationMock.urls.audioFallbackUrl,
            audioHostUrl: self.meetingSessionConfigurationMock.urls.audioHostUrl,
            meetingId: self.meetingSessionConfigurationMock.meetingId,
            attendeeId: self.meetingSessionConfigurationMock.credentials.attendeeId,
            joinToken: self.meetingSessionConfigurationMock.credentials.joinToken,
            callKitEnabled: false,
            audioMode: equal(to: AudioMode.mono48K),
            audioDeviceCapabilities: equal(to: AudioDeviceCapabilities.inputAndOutput),
            enableAudioRedundancy: true,
            reconnectTimeoutMs: self.reconnectTimeoutMs
        )
        verify(videoClientControllerMock).start()
    }

    func testStart_mono48K_callKitEnabled() {
        XCTAssertNoThrow(try defaultAudioVideoController.start(audioVideoConfiguration: AudioVideoConfiguration(audioMode: AudioMode.mono48K, callKitEnabled: true)))

        verify(audioClientControllerMock).start(
            audioFallbackUrl: self.meetingSessionConfigurationMock.urls.audioFallbackUrl,
            audioHostUrl: self.meetingSessionConfigurationMock.urls.audioHostUrl,
            meetingId: self.meetingSessionConfigurationMock.meetingId,
            attendeeId: self.meetingSessionConfigurationMock.credentials.attendeeId,
            joinToken: self.meetingSessionConfigurationMock.credentials.joinToken,
            callKitEnabled: true,
            audioMode: equal(to: AudioMode.mono48K),
            audioDeviceCapabilities: equal(to: AudioDeviceCapabilities.inputAndOutput),
            enableAudioRedundancy: true,
            reconnectTimeoutMs: self.reconnectTimeoutMs
        )
        verify(videoClientControllerMock).start()
    }

    func testStart_mono16K_callKitDisabled() {
        XCTAssertNoThrow(try defaultAudioVideoController.start(audioVideoConfiguration: AudioVideoConfiguration(audioMode: AudioMode.mono16K, callKitEnabled: false)))

        verify(audioClientControllerMock).start(
            audioFallbackUrl: self.meetingSessionConfigurationMock.urls.audioFallbackUrl,
            audioHostUrl: self.meetingSessionConfigurationMock.urls.audioHostUrl,
            meetingId: self.meetingSessionConfigurationMock.meetingId,
            attendeeId: self.meetingSessionConfigurationMock.credentials.attendeeId,
            joinToken: self.meetingSessionConfigurationMock.credentials.joinToken,
            callKitEnabled: false,
            audioMode: equal(to: AudioMode.mono16K),
            audioDeviceCapabilities: equal(to: AudioDeviceCapabilities.inputAndOutput),
            enableAudioRedundancy: true,
            reconnectTimeoutMs: self.reconnectTimeoutMs
        )
        verify(videoClientControllerMock).start()
    }

    func testStart_mono16K_callKitEnabled() {
        XCTAssertNoThrow(try defaultAudioVideoController.start(audioVideoConfiguration: AudioVideoConfiguration(audioMode: AudioMode.mono16K, callKitEnabled: true)))

        verify(audioClientControllerMock).start(
            audioFallbackUrl: self.meetingSessionConfigurationMock.urls.audioFallbackUrl,
            audioHostUrl: self.meetingSessionConfigurationMock.urls.audioHostUrl,
            meetingId: self.meetingSessionConfigurationMock.meetingId,
            attendeeId: self.meetingSessionConfigurationMock.credentials.attendeeId,
            joinToken: self.meetingSessionConfigurationMock.credentials.joinToken,
            callKitEnabled: true,
            audioMode: equal(to: AudioMode.mono16K),
            audioDeviceCapabilities: equal(to: AudioDeviceCapabilities.inputAndOutput),
            enableAudioRedundancy: true,
            reconnectTimeoutMs: self.reconnectTimeoutMs
        )
        verify(videoClientControllerMock).start()
    }

    func testStart_audioDeviceCapabilities() {
        var count = 0
        for capabilities in AudioDeviceCapabilities.allCases {
            count += 1
            XCTAssertNoThrow(try defaultAudioVideoController.start(audioVideoConfiguration: AudioVideoConfiguration(audioDeviceCapabilities: capabilities)))

            verify(audioClientControllerMock).start(
                audioFallbackUrl: self.meetingSessionConfigurationMock.urls.audioFallbackUrl,
                audioHostUrl: self.meetingSessionConfigurationMock.urls.audioHostUrl,
                meetingId: self.meetingSessionConfigurationMock.meetingId,
                attendeeId: self.meetingSessionConfigurationMock.credentials.attendeeId,
                joinToken: self.meetingSessionConfigurationMock.credentials.joinToken,
                callKitEnabled: false,
                audioMode: equal(to: AudioMode.stereo48K),
                audioDeviceCapabilities: equal(to: capabilities),
                enableAudioRedundancy: true,
                reconnectTimeoutMs: self.reconnectTimeoutMs
            )
            verify(videoClientControllerMock, times(count)).start()
        }
    }

    func testStart_audioRedundancyDisabled() {
        XCTAssertNoThrow(try defaultAudioVideoController.start(audioVideoConfiguration: AudioVideoConfiguration(enableAudioRedundancy: false)))

        verify(audioClientControllerMock).start(
            audioFallbackUrl: self.meetingSessionConfigurationMock.urls.audioFallbackUrl,
            audioHostUrl: self.meetingSessionConfigurationMock.urls.audioHostUrl,
            meetingId: self.meetingSessionConfigurationMock.meetingId,
            attendeeId: self.meetingSessionConfigurationMock.credentials.attendeeId,
            joinToken: self.meetingSessionConfigurationMock.credentials.joinToken,
            callKitEnabled: false,
            audioMode: equal(to: AudioMode.stereo48K),
            audioDeviceCapabilities: equal(to: AudioDeviceCapabilities.inputAndOutput),
            enableAudioRedundancy: false,
            reconnectTimeoutMs: self.reconnectTimeoutMs
        )
        verify(videoClientControllerMock).start()
    }
    
    func testStart_120000ReconnectTimeoutMs() {
        let testReconnectTimeoutMs = 120 * 1000
        let audioVideoConfiguration = AudioVideoConfiguration(reconnectTimeoutMs: testReconnectTimeoutMs)
        XCTAssertNoThrow(try defaultAudioVideoController.start(audioVideoConfiguration: audioVideoConfiguration))

        verify(audioClientControllerMock).start(
            audioFallbackUrl: self.meetingSessionConfigurationMock.urls.audioFallbackUrl,
            audioHostUrl: self.meetingSessionConfigurationMock.urls.audioHostUrl,
            meetingId: self.meetingSessionConfigurationMock.meetingId,
            attendeeId: self.meetingSessionConfigurationMock.credentials.attendeeId,
            joinToken: self.meetingSessionConfigurationMock.credentials.joinToken,
            callKitEnabled: false,
            audioMode: equal(to: AudioMode.stereo48K),
            audioDeviceCapabilities: equal(to: AudioDeviceCapabilities.inputAndOutput),
            enableAudioRedundancy: true,
            reconnectTimeoutMs: testReconnectTimeoutMs
        )
        verify(videoClientControllerMock).start()
    }

    func testStop() {
        defaultAudioVideoController.stop()

        verify(audioClientControllerMock).stop()
        verify(videoClientControllerMock).stopAndDestroy()
        verify(appStateMonitorMock).stop()
    }

    func testAddAudioVideoObserver() {
        let audioVideoObserverMock: MockAudioVideoObserver = MockAudioVideoObserver().withEnabledDefaultImplementation(AudioVideoObserverStub())
        defaultAudioVideoController.addAudioVideoObserver(observer: audioVideoObserverMock)

        verify(audioClientObserverMock).subscribeToAudioClientStateChange(observer: equal(to: audioVideoObserverMock))
        verify(videoClientControllerMock).subscribeToVideoClientStateChange(observer: equal(to: audioVideoObserverMock))
    }

    func testRemoveAudioVideoObserver() {
        let audioVideoObserverMock: MockAudioVideoObserver = MockAudioVideoObserver().withEnabledDefaultImplementation(AudioVideoObserverStub())
        defaultAudioVideoController.removeAudioVideoObserver(observer: audioVideoObserverMock)

        verify(audioClientObserverMock).unsubscribeFromAudioClientStateChange(observer: equal(to: audioVideoObserverMock))
        verify(videoClientControllerMock).unsubscribeFromVideoClientStateChange(observer: equal(to: audioVideoObserverMock))
    }

    func testAddMetricsObserver() {
        let metricsObserverMock: MockMetricsObserver = MockMetricsObserver().withEnabledDefaultImplementation(MetricsObserverStub())
        defaultAudioVideoController.addMetricsObserver(observer: metricsObserverMock)

        verify(clientMetricsCollectorMock).subscribeToMetrics(observer: equal(to: metricsObserverMock))
    }

    func testRemoveMetricsObserver() {
        let metricsObserverMock: MockMetricsObserver = MockMetricsObserver().withEnabledDefaultImplementation(MetricsObserverStub())
        defaultAudioVideoController.removeMetricsObserver(observer: metricsObserverMock)

        verify(clientMetricsCollectorMock).unsubscribeFromMetrics(observer: equal(to: metricsObserverMock))
    }

    func testStartLocalVideo() {
        XCTAssertNoThrow(try defaultAudioVideoController.startLocalVideo())

        verify(videoClientControllerMock).startLocalVideo()
    }

    func testStartLocalVideoWithConfig() {
        let config = LocalVideoConfiguration()
        XCTAssertNoThrow(try defaultAudioVideoController.startLocalVideo(config: config))

        verify(videoClientControllerMock).startLocalVideo(config: equal(to: config))
    }

    func testStartLocalVideoWithSource() {
        let cameraCaptureSourceMock: MockCameraCaptureSource = MockCameraCaptureSource().withEnabledDefaultImplementation(CameraCaptureSourceStub())
        defaultAudioVideoController.startLocalVideo(source: cameraCaptureSourceMock)

        verify(videoClientControllerMock).startLocalVideo(source: equal(to: cameraCaptureSourceMock))
    }

    func testStartLocalVideoWithSourceAndConfig() {
        let config = LocalVideoConfiguration()
        let cameraCaptureSourceMock: MockCameraCaptureSource = MockCameraCaptureSource().withEnabledDefaultImplementation(CameraCaptureSourceStub())
        defaultAudioVideoController.startLocalVideo(source: cameraCaptureSourceMock, config: config)

        verify(videoClientControllerMock).startLocalVideo(source: equal(to: cameraCaptureSourceMock), config: equal(to: config))
    }

    func testStopLocalVideo() {
        defaultAudioVideoController.stopLocalVideo()

        verify(videoClientControllerMock).stopLocalVideo()
    }

    func testStartRemoteVideo() {
        defaultAudioVideoController.startRemoteVideo()

        verify(videoClientControllerMock).startRemoteVideo()
    }

    func testStopRemoteVideo() {
        defaultAudioVideoController.stopRemoteVideo()

        verify(videoClientControllerMock).stopRemoteVideo()
    }
}
