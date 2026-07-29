//
//  DefaultAudioVideoControllerTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import AVFoundation
import XCTest

class DefaultAudioVideoControllerTests: CommonTestCase {
    private let reconnectTimeoutMs = 180 * 1000
    
    var audioClientControllerMock: AudioClientControllerSpy!
    var audioClientObserverMock: AudioClientObserverSpy!
    var clientMetricsCollectorMock: ClientMetricsCollectorSpy!
    var videoClientControllerMock: VideoClientControllerSpy!
    var videoTileControllerMock: VideoTileControllerSpy!
    var appStateMonitorMock: AppStateMonitorSpy!
    var defaultAudioVideoController: DefaultAudioVideoController!

    override func setUp() {
        super.setUp()

        audioClientControllerMock = AudioClientControllerSpy()
        audioClientObserverMock = AudioClientObserverSpy()
        clientMetricsCollectorMock = ClientMetricsCollectorSpy()
        videoClientControllerMock = VideoClientControllerSpy()
        videoTileControllerMock = VideoTileControllerSpy()
        appStateMonitorMock = AppStateMonitorSpy()

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

        XCTAssertEqual(audioClientControllerMock.startCalls.filter {
            $0.audioFallbackUrl == self.meetingSessionConfigurationMock.urls.audioFallbackUrl
                && $0.audioHostUrl == self.meetingSessionConfigurationMock.urls.audioHostUrl
                && $0.meetingId == self.meetingSessionConfigurationMock.meetingId
                && $0.attendeeId == self.meetingSessionConfigurationMock.credentials.attendeeId
                && $0.joinToken == self.meetingSessionConfigurationMock.credentials.joinToken
                && $0.callKitEnabled == false
                && $0.audioMode == AudioMode.stereo48K
                && $0.audioDeviceCapabilities == AudioDeviceCapabilities.inputAndOutput
                && $0.enableAudioRedundancy == true
                && $0.reconnectTimeoutMs == self.reconnectTimeoutMs
        }.count, 1)
        XCTAssertEqual(videoClientControllerMock.startCallCount, 1)
        XCTAssertEqual(appStateMonitorMock.startCallCount, 1)
    }

    func testStart_callKitEnabled() {
        let callKitEnabled = true
        XCTAssertNoThrow(try defaultAudioVideoController.start(callKitEnabled: callKitEnabled))

        XCTAssertEqual(audioClientControllerMock.startCalls.filter {
            $0.audioFallbackUrl == self.meetingSessionConfigurationMock.urls.audioFallbackUrl
                && $0.audioHostUrl == self.meetingSessionConfigurationMock.urls.audioHostUrl
                && $0.meetingId == self.meetingSessionConfigurationMock.meetingId
                && $0.attendeeId == self.meetingSessionConfigurationMock.credentials.attendeeId
                && $0.joinToken == self.meetingSessionConfigurationMock.credentials.joinToken
                && $0.callKitEnabled == callKitEnabled
                && $0.audioMode == AudioMode.stereo48K
                && $0.audioDeviceCapabilities == AudioDeviceCapabilities.inputAndOutput
                && $0.enableAudioRedundancy == true
                && $0.reconnectTimeoutMs == self.reconnectTimeoutMs
        }.count, 1)
        XCTAssertEqual(videoClientControllerMock.startCallCount, 1)
    }

    func testStart_mono48K_callKitDisabled() {
        XCTAssertNoThrow(try defaultAudioVideoController.start(audioVideoConfiguration: AudioVideoConfiguration(audioMode: AudioMode.mono48K, callKitEnabled: false)))

        XCTAssertEqual(audioClientControllerMock.startCalls.filter {
            $0.audioFallbackUrl == self.meetingSessionConfigurationMock.urls.audioFallbackUrl
                && $0.audioHostUrl == self.meetingSessionConfigurationMock.urls.audioHostUrl
                && $0.meetingId == self.meetingSessionConfigurationMock.meetingId
                && $0.attendeeId == self.meetingSessionConfigurationMock.credentials.attendeeId
                && $0.joinToken == self.meetingSessionConfigurationMock.credentials.joinToken
                && $0.callKitEnabled == false
                && $0.audioMode == AudioMode.mono48K
                && $0.audioDeviceCapabilities == AudioDeviceCapabilities.inputAndOutput
                && $0.enableAudioRedundancy == true
                && $0.reconnectTimeoutMs == self.reconnectTimeoutMs
        }.count, 1)
        XCTAssertEqual(videoClientControllerMock.startCallCount, 1)
    }

    func testStart_mono48K_callKitEnabled() {
        XCTAssertNoThrow(try defaultAudioVideoController.start(audioVideoConfiguration: AudioVideoConfiguration(audioMode: AudioMode.mono48K, callKitEnabled: true)))

        XCTAssertEqual(audioClientControllerMock.startCalls.filter {
            $0.audioFallbackUrl == self.meetingSessionConfigurationMock.urls.audioFallbackUrl
                && $0.audioHostUrl == self.meetingSessionConfigurationMock.urls.audioHostUrl
                && $0.meetingId == self.meetingSessionConfigurationMock.meetingId
                && $0.attendeeId == self.meetingSessionConfigurationMock.credentials.attendeeId
                && $0.joinToken == self.meetingSessionConfigurationMock.credentials.joinToken
                && $0.callKitEnabled == true
                && $0.audioMode == AudioMode.mono48K
                && $0.audioDeviceCapabilities == AudioDeviceCapabilities.inputAndOutput
                && $0.enableAudioRedundancy == true
                && $0.reconnectTimeoutMs == self.reconnectTimeoutMs
        }.count, 1)
        XCTAssertEqual(videoClientControllerMock.startCallCount, 1)
    }

    func testStart_mono16K_callKitDisabled() {
        XCTAssertNoThrow(try defaultAudioVideoController.start(audioVideoConfiguration: AudioVideoConfiguration(audioMode: AudioMode.mono16K, callKitEnabled: false)))

        XCTAssertEqual(audioClientControllerMock.startCalls.filter {
            $0.audioFallbackUrl == self.meetingSessionConfigurationMock.urls.audioFallbackUrl
                && $0.audioHostUrl == self.meetingSessionConfigurationMock.urls.audioHostUrl
                && $0.meetingId == self.meetingSessionConfigurationMock.meetingId
                && $0.attendeeId == self.meetingSessionConfigurationMock.credentials.attendeeId
                && $0.joinToken == self.meetingSessionConfigurationMock.credentials.joinToken
                && $0.callKitEnabled == false
                && $0.audioMode == AudioMode.mono16K
                && $0.audioDeviceCapabilities == AudioDeviceCapabilities.inputAndOutput
                && $0.enableAudioRedundancy == true
                && $0.reconnectTimeoutMs == self.reconnectTimeoutMs
        }.count, 1)
        XCTAssertEqual(videoClientControllerMock.startCallCount, 1)
    }

    func testStart_mono16K_callKitEnabled() {
        XCTAssertNoThrow(try defaultAudioVideoController.start(audioVideoConfiguration: AudioVideoConfiguration(audioMode: AudioMode.mono16K, callKitEnabled: true)))

        XCTAssertEqual(audioClientControllerMock.startCalls.filter {
            $0.audioFallbackUrl == self.meetingSessionConfigurationMock.urls.audioFallbackUrl
                && $0.audioHostUrl == self.meetingSessionConfigurationMock.urls.audioHostUrl
                && $0.meetingId == self.meetingSessionConfigurationMock.meetingId
                && $0.attendeeId == self.meetingSessionConfigurationMock.credentials.attendeeId
                && $0.joinToken == self.meetingSessionConfigurationMock.credentials.joinToken
                && $0.callKitEnabled == true
                && $0.audioMode == AudioMode.mono16K
                && $0.audioDeviceCapabilities == AudioDeviceCapabilities.inputAndOutput
                && $0.enableAudioRedundancy == true
                && $0.reconnectTimeoutMs == self.reconnectTimeoutMs
        }.count, 1)
        XCTAssertEqual(videoClientControllerMock.startCallCount, 1)
    }

    func testStart_audioDeviceCapabilities() {
        var count = 0
        for capabilities in AudioDeviceCapabilities.allCases {
            count += 1
            XCTAssertNoThrow(try defaultAudioVideoController.start(audioVideoConfiguration: AudioVideoConfiguration(audioDeviceCapabilities: capabilities)))

        XCTAssertEqual(audioClientControllerMock.startCalls.filter {
                $0.audioFallbackUrl == self.meetingSessionConfigurationMock.urls.audioFallbackUrl
                    && $0.audioHostUrl == self.meetingSessionConfigurationMock.urls.audioHostUrl
                    && $0.meetingId == self.meetingSessionConfigurationMock.meetingId
                    && $0.attendeeId == self.meetingSessionConfigurationMock.credentials.attendeeId
                    && $0.joinToken == self.meetingSessionConfigurationMock.credentials.joinToken
                    && $0.callKitEnabled == false
                    && $0.audioMode == AudioMode.stereo48K
                    && $0.audioDeviceCapabilities == capabilities
                    && $0.enableAudioRedundancy == true
                    && $0.reconnectTimeoutMs == self.reconnectTimeoutMs
            }.count, 1)
            XCTAssertEqual(videoClientControllerMock.startCallCount, count)
        }
    }

    func testStart_audioRedundancyDisabled() {
        XCTAssertNoThrow(try defaultAudioVideoController.start(audioVideoConfiguration: AudioVideoConfiguration(enableAudioRedundancy: false)))

        XCTAssertEqual(audioClientControllerMock.startCalls.filter {
            $0.audioFallbackUrl == self.meetingSessionConfigurationMock.urls.audioFallbackUrl
                && $0.audioHostUrl == self.meetingSessionConfigurationMock.urls.audioHostUrl
                && $0.meetingId == self.meetingSessionConfigurationMock.meetingId
                && $0.attendeeId == self.meetingSessionConfigurationMock.credentials.attendeeId
                && $0.joinToken == self.meetingSessionConfigurationMock.credentials.joinToken
                && $0.callKitEnabled == false
                && $0.audioMode == AudioMode.stereo48K
                && $0.audioDeviceCapabilities == AudioDeviceCapabilities.inputAndOutput
                && $0.enableAudioRedundancy == false
                && $0.reconnectTimeoutMs == self.reconnectTimeoutMs
        }.count, 1)
        XCTAssertEqual(videoClientControllerMock.startCallCount, 1)
    }
    
    func testStart_120000ReconnectTimeoutMs() {
        let testReconnectTimeoutMs = 120 * 1000
        let audioVideoConfiguration = AudioVideoConfiguration(reconnectTimeoutMs: testReconnectTimeoutMs)
        XCTAssertNoThrow(try defaultAudioVideoController.start(audioVideoConfiguration: audioVideoConfiguration))

        XCTAssertEqual(audioClientControllerMock.startCalls.filter {
            $0.audioFallbackUrl == self.meetingSessionConfigurationMock.urls.audioFallbackUrl
                && $0.audioHostUrl == self.meetingSessionConfigurationMock.urls.audioHostUrl
                && $0.meetingId == self.meetingSessionConfigurationMock.meetingId
                && $0.attendeeId == self.meetingSessionConfigurationMock.credentials.attendeeId
                && $0.joinToken == self.meetingSessionConfigurationMock.credentials.joinToken
                && $0.callKitEnabled == false
                && $0.audioMode == AudioMode.stereo48K
                && $0.audioDeviceCapabilities == AudioDeviceCapabilities.inputAndOutput
                && $0.enableAudioRedundancy == true
                && $0.reconnectTimeoutMs == testReconnectTimeoutMs
        }.count, 1)
        XCTAssertEqual(videoClientControllerMock.startCallCount, 1)
    }

    func testStop() {
        defaultAudioVideoController.stop()

        XCTAssertEqual(audioClientControllerMock.stopCallCount, 1)
        XCTAssertEqual(videoClientControllerMock.stopAndDestroyCallCount, 1)
        XCTAssertEqual(appStateMonitorMock.stopCallCount, 1)
    }

    func testAddAudioVideoObserver() {
        let audioVideoObserverMock = AudioVideoObserverSpy()
        defaultAudioVideoController.addAudioVideoObserver(observer: audioVideoObserverMock)

        XCTAssertEqual(audioClientObserverMock.subscribeToAudioClientStateChangeCalls.filter { $0 === audioVideoObserverMock }.count, 1)
        XCTAssertEqual(videoClientControllerMock.subscribeToVideoClientStateChangeCalls.filter { $0 === audioVideoObserverMock }.count, 1)
    }

    func testRemoveAudioVideoObserver() {
        let audioVideoObserverMock = AudioVideoObserverSpy()
        defaultAudioVideoController.removeAudioVideoObserver(observer: audioVideoObserverMock)

        XCTAssertEqual(audioClientObserverMock.unsubscribeFromAudioClientStateChangeCalls.filter { $0 === audioVideoObserverMock }.count, 1)
        XCTAssertEqual(videoClientControllerMock.unsubscribeFromVideoClientStateChangeCalls.filter { $0 === audioVideoObserverMock }.count, 1)
    }

    func testAddMetricsObserver() {
        let metricsObserverMock = MetricsObserverSpy()
        defaultAudioVideoController.addMetricsObserver(observer: metricsObserverMock)

        XCTAssertEqual(clientMetricsCollectorMock.subscribeToMetricsCalls.filter { $0 === metricsObserverMock }.count, 1)
    }

    func testRemoveMetricsObserver() {
        let metricsObserverMock = MetricsObserverSpy()
        defaultAudioVideoController.removeMetricsObserver(observer: metricsObserverMock)

        XCTAssertEqual(clientMetricsCollectorMock.unsubscribeFromMetricsCalls.filter { $0 === metricsObserverMock }.count, 1)
    }

    func testStartLocalVideo() {
        XCTAssertNoThrow(try defaultAudioVideoController.startLocalVideo())

        XCTAssertEqual(videoClientControllerMock.startLocalVideoCalls.filter { $0.source == nil && $0.config == nil }.count, 1)
    }

    func testStartLocalVideoWithConfig() {
        let config = LocalVideoConfiguration()
        XCTAssertNoThrow(try defaultAudioVideoController.startLocalVideo(config: config))

        XCTAssertEqual(videoClientControllerMock.startLocalVideoCalls.filter { $0.source == nil && $0.config === config }.count, 1)
    }

    func testStartLocalVideoWithSource() {
        let cameraCaptureSourceMock = CameraCaptureSourceSpy()
        defaultAudioVideoController.startLocalVideo(source: cameraCaptureSourceMock)

        XCTAssertEqual(videoClientControllerMock.startLocalVideoCalls.filter { $0.source === cameraCaptureSourceMock && $0.config == nil }.count, 1)
    }

    func testStartLocalVideoWithSourceAndConfig() {
        let config = LocalVideoConfiguration()
        let cameraCaptureSourceMock = CameraCaptureSourceSpy()
        defaultAudioVideoController.startLocalVideo(source: cameraCaptureSourceMock, config: config)

        XCTAssertEqual(videoClientControllerMock.startLocalVideoCalls.filter { $0.source === cameraCaptureSourceMock && $0.config === config }.count, 1)
    }

    func testStopLocalVideo() {
        defaultAudioVideoController.stopLocalVideo()

        XCTAssertEqual(videoClientControllerMock.stopLocalVideoCallCount, 1)
    }

    func testStartRemoteVideo() {
        defaultAudioVideoController.startRemoteVideo()

        XCTAssertEqual(videoClientControllerMock.startRemoteVideoCallCount, 1)
    }

    func testStopRemoteVideo() {
        defaultAudioVideoController.stopRemoteVideo()

        XCTAssertEqual(videoClientControllerMock.stopRemoteVideoCallCount, 1)
    }
}
