//
//  DefaultContentShareVideoClientControllerTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import AmazonChimeSDKMedia
import XCTest

class DefaultContentShareVideoClientControllerTests: CommonTestCase {
    var videoClientMock: VideoClientProtocolSpy!
    var videoSourceMock: VideoSourceSpy!
    var clientMetricsLollectorMock: ClientMetricsCollectorSpy!
    var eventAnalyticsControllerMock: EventAnalyticsControllerSpy!
    var defaultContentShareVideoClientController: DefaultContentShareVideoClientController!
    var defaultContentShareVideoClientControllerNone: DefaultContentShareVideoClientController!
    var defaultContentShareVideoClientControllerHigh: DefaultContentShareVideoClientController!

    override func setUp() {
        super.setUp()

        videoClientMock = VideoClientProtocolSpy()
        videoSourceMock = VideoSourceSpy()
        eventAnalyticsControllerMock = EventAnalyticsControllerSpy()
        loggerMock = LoggerSpy()
        clientMetricsLollectorMock = ClientMetricsCollectorSpy()
        defaultContentShareVideoClientController =
            DefaultContentShareVideoClientController(videoClient: videoClientMock,
                                                     configuration: meetingSessionConfigurationMock,
                                                     logger: loggerMock,
                                                     clientMetricsCollector: clientMetricsLollectorMock,
                                                     eventAnalyticsController: eventAnalyticsControllerMock)
        defaultContentShareVideoClientControllerNone =
            DefaultContentShareVideoClientController(videoClient: videoClientMock,
                                                     configuration: meetingSessionConfigurationMockNone,
                                                     logger: loggerMock,
                                                     clientMetricsCollector: clientMetricsLollectorMock,
                                                     eventAnalyticsController: eventAnalyticsControllerMock)
        defaultContentShareVideoClientControllerHigh =
            DefaultContentShareVideoClientController(videoClient: videoClientMock,
                                                     configuration: meetingSessionConfigurationMockHigh,
                                                     logger: loggerMock,
                                                     clientMetricsCollector: clientMetricsLollectorMock,
                                                     eventAnalyticsController: eventAnalyticsControllerMock)

        videoSourceMock.videoContentHint = VideoContentHint.text
    }

    func testStartVideoShareWithContentMaxResolutionNone() {
        defaultContentShareVideoClientControllerNone.startVideoShare(source: videoSourceMock)

        XCTAssertEqual(videoClientMock.startCalls.filter { $0.callId == self.meetingId && $0.token == self.joinToken && $0.sending == false }.count, 0)
        XCTAssertEqual(videoClientMock.setExternalVideoSourceCalls.count, 0)
        XCTAssertEqual(videoClientMock.setSendingCalls.filter { $0 == true }.count, 0)
    }

    func testStartVideoShareWithContentMaxResolutionUHD() {
        defaultContentShareVideoClientControllerHigh.startVideoShare(source: videoSourceMock)

        XCTAssertEqual(videoClientMock.startCalls.filter { $0.callId == self.meetingId && $0.token == self.joinToken && $0.sending == false }.count, 1)
        XCTAssertEqual(videoClientMock.setExternalVideoSourceCalls.count, 1)
        XCTAssertEqual(videoClientMock.setMaxBitRateKbpsCalls.filter { $0 == VideoBitrateConstants().contentHighResolutionBitrateKbps }.count, 1)
        XCTAssertEqual(videoClientMock.setContentMaxResolutionUHDCalls.filter { $0 == true }.count, 1)
        XCTAssertEqual(videoClientMock.setSendingCalls.filter { $0 == true }.count, 1)
    }

    func testStartVideoShareFirstTime() {
        defaultContentShareVideoClientController.startVideoShare(source: videoSourceMock)

        XCTAssertEqual(videoClientMock.startCalls.filter { $0.callId == self.meetingId && $0.token == self.joinToken && $0.sending == false }.count, 1)
        XCTAssertEqual(videoClientMock.setExternalVideoSourceCalls.count, 1)
        XCTAssertEqual(videoClientMock.setSendingCalls.filter { $0 == true }.count, 1)
    }

    func testStartVideoShareWithConfig() {
        let config = LocalVideoConfiguration(maxBitRateKbps: 300)
        defaultContentShareVideoClientController.startVideoShare(source: videoSourceMock, config: config)

        XCTAssertEqual(videoClientMock.setExternalVideoSourceCalls.count, 1)
        XCTAssertEqual(videoClientMock.setSendingCalls.filter { $0 == true }.count, 1)
        XCTAssertEqual(videoClientMock.setMaxBitRateKbpsCalls.filter { $0 == UInt32(300) }.count, 1)
    }

    func testStartVideoShareAfterStart() {
        videoClientMock.startHandler = {
            self.defaultContentShareVideoClientController.videoClientDidConnect(nil, controlStatus: 1)
        }
        videoClientMock.stopHandler = {
            self.defaultContentShareVideoClientController.videoClientDidStop(nil)
        }

        defaultContentShareVideoClientController.startVideoShare(source: videoSourceMock)
        defaultContentShareVideoClientController.startVideoShare(source: videoSourceMock)

        XCTAssertEqual(videoClientMock.startCalls.filter { $0.callId == self.meetingId && $0.token == self.joinToken && $0.sending == false }.count, 1)
        XCTAssertEqual(videoClientMock.setExternalVideoSourceCalls.count, 2)
        XCTAssertEqual(videoClientMock.setSendingCalls.filter { $0 == true }.count, 2)
    }

    func testStopVideoShareAfterStart() {
        videoClientMock.startHandler = {
            self.defaultContentShareVideoClientController.videoClientDidConnect(nil, controlStatus: 1)
        }
        videoClientMock.stopHandler = {
            self.defaultContentShareVideoClientController.videoClientDidStop(nil)
        }

        defaultContentShareVideoClientController.startVideoShare(source: videoSourceMock)
        defaultContentShareVideoClientController.stopVideoShare()

        XCTAssertEqual(videoClientMock.setSendingCalls.filter { $0 == false }.count, 1)
        XCTAssertEqual(videoClientMock.stopCallCount, 1)
        XCTAssertEqual(eventAnalyticsControllerMock.publishEventCalls.filter { $0.name == .contentShareStopped }.count, 1)
    }

    func testStopVideoShareBeforeStart() {
        defaultContentShareVideoClientController.stopVideoShare()

        XCTAssertEqual(videoClientMock.setSendingCalls.filter { $0 == false }.count, 0)
        XCTAssertEqual(videoClientMock.stopCallCount, 0)
    }
    
    func testVideoClientDidReceiveEvent_ShouldPublishSignalingDroppedEvent_WhenEventTypeIsSignalingDropped() {
        let event: video_client_event = video_client_event(timestamp: 1,
                                                           event_type: VIDEO_CLIENT_EVENT_TYPE_SIGNALING_DROPPED,
                                                           signaling_dropped_error: VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_INTERNAL_SERVER_ERROR,
                                                           signaling_open_duration_ms: 123,
                                                           ice_gathering_duration_ms: 0)
                 let mediaVideoClientMock = VideoClientMock()
        
        defaultContentShareVideoClientController.videoClient(mediaVideoClientMock, didReceive: event)
        
        let captured = eventAnalyticsControllerMock.publishEventCalls.filter { $0.name == .contentShareSignalingDropped }
        XCTAssertEqual(captured.count, 1)
        
        let error = captured.last?.attributes?[EventAttributeName.signalingDroppedError] as? SignalingDroppedError
        XCTAssertEqual(error, SignalingDroppedError.internalServerError)
    }
    
    func testVideoClientDidReceiveEvent_ShouldPublishSignalingOpenedEvent_WhenEventTypeIsSignalingOpened() {
        let event: video_client_event = video_client_event(timestamp: 1,
                                                           event_type: VIDEO_CLIENT_EVENT_TYPE_SIGNALING_OPENED,
                                                           signaling_dropped_error: VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_INTERNAL_SERVER_ERROR,
                                                           signaling_open_duration_ms: 123,
                                                           ice_gathering_duration_ms: 0)
                 let mediaVideoClientMock = VideoClientMock()
        
        defaultContentShareVideoClientController.videoClient(mediaVideoClientMock, didReceive: event)
        
        let captured = eventAnalyticsControllerMock.publishEventCalls.filter { $0.name == .contentShareSignalingOpened }
        XCTAssertEqual(captured.count, 1)
        
        let duration = captured.last?.attributes?[EventAttributeName.signalingOpenDurationMs] as? Int64
        XCTAssertEqual(duration, 123)
    }
    
    func testVideoClientDidReceiveEvent_ShouldPublishIceGatheringCompleted_WhenEventTypeIsIceGatheringCompleted() {
        let event: video_client_event = video_client_event(timestamp: 1,
                                                           event_type: VIDEO_CLIENT_EVENT_TYPE_ICE_GATHERING_COMPLETED,
                                                           signaling_dropped_error: VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_INTERNAL_SERVER_ERROR,
                                                           signaling_open_duration_ms: 123,
                                                           ice_gathering_duration_ms: 456)
                 let mediaVideoClientMock = VideoClientMock()
        
        defaultContentShareVideoClientController.videoClient(mediaVideoClientMock, didReceive: event)
        
        let captured = eventAnalyticsControllerMock.publishEventCalls.filter { $0.name == .contentShareIceGatheringCompleted }
        XCTAssertEqual(captured.count, 1)
        
        let duration = captured.last?.attributes?[EventAttributeName.iceGatheringDurationMs] as? Int64
        XCTAssertEqual(duration, 456)
    }
    
    func testStartVideoShare_ShouldPublishContentShareStartRequestedEvent() {
        defaultContentShareVideoClientController.startVideoShare(source: videoSourceMock)

        XCTAssertEqual(eventAnalyticsControllerMock.publishEventCalls.filter { $0.name == .contentShareStartRequested }.count, 1)
    }
    
    func testVideoClientDidConnect_ShouldPublishContentShareStartedEvent() {
        defaultContentShareVideoClientController.videoClientDidConnect(nil, controlStatus: 0)

        XCTAssertEqual(eventAnalyticsControllerMock.publishEventCalls.filter { $0.name == .contentShareStarted }.count, 1)
    }
    
    func testVideoClientDidFail_ShouldPublishContentShareFailedEvent() {
                 defaultContentShareVideoClientController.videoClientDidFail(nil,
                                                                    status: VIDEO_CLIENT_ERR_PROXY_AUTHENTICATION_FAILED,
                                                                    controlStatus: 0)
        
        let captured = eventAnalyticsControllerMock.publishEventCalls.filter { $0.name == .contentShareFailed }
        XCTAssertEqual(captured.count, 1)
        
        let error = captured.last?.attributes?[EventAttributeName.contentShareError] as? VideoClientFailedError
        XCTAssertEqual(error, VideoClientFailedError.authenticationFailed)
    }
    
    func testVideoClientDidStop_ShouldPublishContentShareStoppedEvent() {
        defaultContentShareVideoClientController.videoClientDidStop(nil)

        XCTAssertEqual(eventAnalyticsControllerMock.publishEventCalls.filter { $0.name == .contentShareStopped }.count, 1)
    }
}
