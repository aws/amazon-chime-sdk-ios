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

    private func verifyAudioStart(
        callKitEnabled: Bool = false,
        audioMode: AudioMode = .stereo48K,
        audioDeviceCapabilities: AudioDeviceCapabilities = .inputAndOutput,
        enableAudioRedundancy: Bool = true,
        reconnectTimeoutMs: Int? = nil,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let expectedReconnectTimeoutMs = reconnectTimeoutMs ?? self.reconnectTimeoutMs

        verify(audioClientControllerMock.startCalls, file: file, line: line) {
            $0.audioFallbackUrl == self.meetingSessionConfigurationMock.urls.audioFallbackUrl
                && $0.audioHostUrl == self.meetingSessionConfigurationMock.urls.audioHostUrl
                && $0.meetingId == self.meetingSessionConfigurationMock.meetingId
                && $0.attendeeId == self.meetingSessionConfigurationMock.credentials.attendeeId
                && $0.joinToken == self.meetingSessionConfigurationMock.credentials.joinToken
                && $0.callKitEnabled == callKitEnabled
                && $0.audioMode == audioMode
                && $0.audioDeviceCapabilities == audioDeviceCapabilities
                && $0.enableAudioRedundancy == enableAudioRedundancy
                && $0.reconnectTimeoutMs == expectedReconnectTimeoutMs
        }
    }

    func testStart() {
        XCTAssertNoThrow(try defaultAudioVideoController.start())

        verifyAudioStart()
        verify(videoClientControllerMock.startCallCount)
        verify(appStateMonitorMock.startCallCount)
    }

    func testStart_callKitEnabled() {
        let callKitEnabled = true
        XCTAssertNoThrow(try defaultAudioVideoController.start(callKitEnabled: callKitEnabled))

        verifyAudioStart(callKitEnabled: callKitEnabled)
        verify(videoClientControllerMock.startCallCount)
    }

    func testStart_mono48K_callKitDisabled() {
        XCTAssertNoThrow(try defaultAudioVideoController.start(audioVideoConfiguration: AudioVideoConfiguration(audioMode: AudioMode.mono48K, callKitEnabled: false)))

        verifyAudioStart(audioMode: .mono48K)
        verify(videoClientControllerMock.startCallCount)
    }

    func testStart_mono48K_callKitEnabled() {
        XCTAssertNoThrow(try defaultAudioVideoController.start(audioVideoConfiguration: AudioVideoConfiguration(audioMode: AudioMode.mono48K, callKitEnabled: true)))

        verifyAudioStart(callKitEnabled: true, audioMode: .mono48K)
        verify(videoClientControllerMock.startCallCount)
    }

    func testStart_mono16K_callKitDisabled() {
        XCTAssertNoThrow(try defaultAudioVideoController.start(audioVideoConfiguration: AudioVideoConfiguration(audioMode: AudioMode.mono16K, callKitEnabled: false)))

        verifyAudioStart(audioMode: .mono16K)
        verify(videoClientControllerMock.startCallCount)
    }

    func testStart_mono16K_callKitEnabled() {
        XCTAssertNoThrow(try defaultAudioVideoController.start(audioVideoConfiguration: AudioVideoConfiguration(audioMode: AudioMode.mono16K, callKitEnabled: true)))

        verifyAudioStart(callKitEnabled: true, audioMode: .mono16K)
        verify(videoClientControllerMock.startCallCount)
    }

    func testStart_audioDeviceCapabilities() {
        var count = 0
        for capabilities in AudioDeviceCapabilities.allCases {
            count += 1
            XCTAssertNoThrow(try defaultAudioVideoController.start(audioVideoConfiguration: AudioVideoConfiguration(audioDeviceCapabilities: capabilities)))

            verifyAudioStart(audioDeviceCapabilities: capabilities)
            XCTAssertEqual(videoClientControllerMock.startCallCount, count)
        }
    }

    func testStart_audioRedundancyDisabled() {
        XCTAssertNoThrow(try defaultAudioVideoController.start(audioVideoConfiguration: AudioVideoConfiguration(enableAudioRedundancy: false)))

        verifyAudioStart(enableAudioRedundancy: false)
        verify(videoClientControllerMock.startCallCount)
    }
    
    func testStart_120000ReconnectTimeoutMs() {
        let testReconnectTimeoutMs = 120 * 1000
        let audioVideoConfiguration = AudioVideoConfiguration(reconnectTimeoutMs: testReconnectTimeoutMs)
        XCTAssertNoThrow(try defaultAudioVideoController.start(audioVideoConfiguration: audioVideoConfiguration))

        verifyAudioStart(reconnectTimeoutMs: testReconnectTimeoutMs)
        verify(videoClientControllerMock.startCallCount)
    }

    func testStop() {
        defaultAudioVideoController.stop()

        verify(audioClientControllerMock.stopCallCount)
        verify(videoClientControllerMock.stopAndDestroyCallCount)
        verify(appStateMonitorMock.stopCallCount)
    }

    func testAddAudioVideoObserver() {
        let audioVideoObserverMock = AudioVideoObserverSpy()
        defaultAudioVideoController.addAudioVideoObserver(observer: audioVideoObserverMock)

        verifyIdentical(audioClientObserverMock.subscribeToAudioClientStateChangeCalls, to: audioVideoObserverMock)
        verifyIdentical(videoClientControllerMock.subscribeToVideoClientStateChangeCalls, to: audioVideoObserverMock)
    }

    func testRemoveAudioVideoObserver() {
        let audioVideoObserverMock = AudioVideoObserverSpy()
        defaultAudioVideoController.removeAudioVideoObserver(observer: audioVideoObserverMock)

        verifyIdentical(audioClientObserverMock.unsubscribeFromAudioClientStateChangeCalls, to: audioVideoObserverMock)
        verifyIdentical(videoClientControllerMock.unsubscribeFromVideoClientStateChangeCalls, to: audioVideoObserverMock)
    }

    func testAddMetricsObserver() {
        let metricsObserverMock = MetricsObserverSpy()
        defaultAudioVideoController.addMetricsObserver(observer: metricsObserverMock)

        verifyIdentical(clientMetricsCollectorMock.subscribeToMetricsCalls, to: metricsObserverMock)
    }

    func testRemoveMetricsObserver() {
        let metricsObserverMock = MetricsObserverSpy()
        defaultAudioVideoController.removeMetricsObserver(observer: metricsObserverMock)

        verifyIdentical(clientMetricsCollectorMock.unsubscribeFromMetricsCalls, to: metricsObserverMock)
    }

    func testStartLocalVideo() {
        XCTAssertNoThrow(try defaultAudioVideoController.startLocalVideo())

        verify(videoClientControllerMock.startLocalVideoCalls) { $0.source == nil && $0.config == nil }
    }

    func testStartLocalVideoWithConfig() {
        let config = LocalVideoConfiguration()
        XCTAssertNoThrow(try defaultAudioVideoController.startLocalVideo(config: config))

        verify(videoClientControllerMock.startLocalVideoCalls) { $0.source == nil && $0.config === config }
    }

    func testStartLocalVideoWithSource() {
        let cameraCaptureSourceMock = CameraCaptureSourceSpy()
        defaultAudioVideoController.startLocalVideo(source: cameraCaptureSourceMock)

        verify(videoClientControllerMock.startLocalVideoCalls) {
            $0.source === cameraCaptureSourceMock && $0.config == nil
        }
    }

    func testStartLocalVideoWithSourceAndConfig() {
        let config = LocalVideoConfiguration()
        let cameraCaptureSourceMock = CameraCaptureSourceSpy()
        defaultAudioVideoController.startLocalVideo(source: cameraCaptureSourceMock, config: config)

        verify(videoClientControllerMock.startLocalVideoCalls) {
            $0.source === cameraCaptureSourceMock && $0.config === config
        }
    }

    func testStopLocalVideo() {
        defaultAudioVideoController.stopLocalVideo()

        verify(videoClientControllerMock.stopLocalVideoCallCount)
    }

    func testStartRemoteVideo() {
        defaultAudioVideoController.startRemoteVideo()

        verify(videoClientControllerMock.startRemoteVideoCallCount)
    }

    func testStopRemoteVideo() {
        defaultAudioVideoController.stopRemoteVideo()

        verify(videoClientControllerMock.stopRemoteVideoCallCount)
    }
}
