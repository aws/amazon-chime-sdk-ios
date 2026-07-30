//
//  DefaultVideoClientControllerTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import AmazonChimeSDKMedia
import XCTest

class DefaultVideoClientControllerTests: CommonTestCase {
    let topic = "topic"
    let testMessage = "test"

    var videoClientMock: VideoClientProtocolSpy!
    var clientMetricsCollectorMock: ClientMetricsCollectorSpy!
    var eventAnalyticsControllerMock: EventAnalyticsControllerSpy!
    var videoSourceMock: VideoSourceSpy!

    var defaultVideoClientController: DefaultVideoClientController!
    var defaultVideoClientControllerNone: DefaultVideoClientController!
    var defaultVideoClientControllerHigh: DefaultVideoClientController!

    override func setUp() {
        super.setUp()

        videoSourceMock = VideoSourceSpy()
        videoClientMock = VideoClientProtocolSpy()
        clientMetricsCollectorMock = ClientMetricsCollectorSpy()
        eventAnalyticsControllerMock = EventAnalyticsControllerSpy()

        defaultVideoClientController = DefaultVideoClientController(videoClient: videoClientMock,
                                                                    clientMetricsCollector: clientMetricsCollectorMock,
                                                                    configuration: meetingSessionConfigurationMock,
                                                                    logger: loggerMock,
                                                                    eventAnalyticsController: eventAnalyticsControllerMock)
        defaultVideoClientControllerNone = DefaultVideoClientController(videoClient: videoClientMock,
                                                                    clientMetricsCollector: clientMetricsCollectorMock,
                                                                    configuration: meetingSessionConfigurationMockNone,
                                                                    logger: loggerMock,
                                                                    eventAnalyticsController: eventAnalyticsControllerMock)
        defaultVideoClientControllerHigh = DefaultVideoClientController(videoClient: videoClientMock,
                                                                    clientMetricsCollector: clientMetricsCollectorMock,
                                                                    configuration: meetingSessionConfigurationMockHigh,
                                                                    logger: loggerMock,
                                                                    eventAnalyticsController: eventAnalyticsControllerMock)
        videoSourceMock.videoContentHint = VideoContentHint.text
    }

    func testSendDataMessage_videoClientNotStarted() {
        XCTAssertNoThrow(try defaultVideoClientController.sendDataMessage(topic: topic, data: testMessage))

        verifyEqual(loggerMock.errorCalls, to: "Cannot send data message because videoClientState=uninitialized")
        verify(videoClientMock.sendDataMessageCalls, never())
    }

    func testSendDataMessage_negativeLifetimeMs() {
        defaultVideoClientController.start()
        XCTAssertThrowsError(try defaultVideoClientController.sendDataMessage(topic: topic, data: testMessage, lifetimeMs: -1)) { error in
            XCTAssertEqual(error as? SendDataMessageError, SendDataMessageError.negativeLifetimeParameter)
        }

        verify(videoClientMock.sendDataMessageCalls, never())
    }

    func testSendDataMessage_invalidTopic() {
        defaultVideoClientController.start()
        XCTAssertThrowsError(try defaultVideoClientController.sendDataMessage(topic: "$invalid$", data: testMessage)) { error in
            XCTAssertEqual(error as? SendDataMessageError, SendDataMessageError.invalidTopic)
        }

        verify(videoClientMock.sendDataMessageCalls, never())
    }

    func testSendDataMessage_sendString() {
        defaultVideoClientController.start()
        XCTAssertNoThrow(try defaultVideoClientController.sendDataMessage(topic: topic, data: testMessage))

        verify(videoClientMock.sendDataMessageCalls) { $0.topic == self.topic && $0.lifetimeMs == Int32(0) }
    }

    func testSendDataMessage_sendByteArray() {
        defaultVideoClientController.start()
        XCTAssertNoThrow(try defaultVideoClientController.sendDataMessage(topic: topic, data: [116, 101, 115, 116]))

        verify(videoClientMock.sendDataMessageCalls) { $0.topic == self.topic && $0.lifetimeMs == Int32(0) }
    }

    func testSendDataMessage_sendJson() {
        defaultVideoClientController.start()
        XCTAssertNoThrow(try defaultVideoClientController.sendDataMessage(topic: topic, data: ["key": "value"]))

        verify(videoClientMock.sendDataMessageCalls) { $0.topic == self.topic && $0.lifetimeMs == Int32(0) }
    }

    func testSendDataMessage_sendInvalidData() {
        defaultVideoClientController.start()
        XCTAssertThrowsError(try defaultVideoClientController.sendDataMessage(topic: topic, data: 0)) { error in
            XCTAssertEqual(error as? SendDataMessageError, SendDataMessageError.invalidData)
        }

        verify(videoClientMock.sendDataMessageCalls, never()) { $0.topic == self.topic && $0.lifetimeMs == Int32(0) }
    }

    func testSendLocalVideo() {
        defaultVideoClientController.start()
        XCTAssertNoThrow(try defaultVideoClientController.startLocalVideo())

        verify(videoClientMock.setExternalVideoSourceCalls)
        verifyEqual(videoClientMock.setSendingCalls, to: true)
    }

    func testSendLocalVideoNone() {
        defaultVideoClientControllerNone.start()
        XCTAssertNoThrow(try defaultVideoClientControllerNone.startLocalVideo())

        verify(videoClientMock.setExternalVideoSourceCalls, never())
        verifyEqual(videoClientMock.setSendingCalls, never(), to: true)
    }

    func testSendLocalVideoHigh() {
        defaultVideoClientControllerHigh.start()
        XCTAssertNoThrow(try defaultVideoClientControllerHigh.startLocalVideo())

        verify(videoClientMock.setExternalVideoSourceCalls)
        verifyEqual(videoClientMock.setMaxBitRateKbpsCalls, to: VideoBitrateConstants().videoHighResolutionBitrateKbps)
        verifyEqual(videoClientMock.setSendingCalls, to: true)
    }

    func testSendLocalVideoWithConfig() {
        defaultVideoClientController.start()
        let config = LocalVideoConfiguration(maxBitRateKbps: 300)
        XCTAssertNoThrow(try defaultVideoClientController.startLocalVideo(config: config))

        verify(videoClientMock.setExternalVideoSourceCalls)
        verifyEqual(videoClientMock.setSendingCalls, to: true)
        verifyEqual(videoClientMock.setMaxBitRateKbpsCalls, to: UInt32(300))
    }

    func testSendLocalVideoWithSource() {
        defaultVideoClientController.start()
        defaultVideoClientController.startLocalVideo(source: videoSourceMock)

        verify(videoClientMock.setExternalVideoSourceCalls)
        verifyEqual(videoClientMock.setSendingCalls, to: true)
    }

    func testSendLocalVideoWithSourceAndConfig() {
        defaultVideoClientController.start()
        let config = LocalVideoConfiguration(maxBitRateKbps: 300)
        defaultVideoClientController.startLocalVideo(source: videoSourceMock, config: config)

        verify(videoClientMock.setExternalVideoSourceCalls)
        verifyEqual(videoClientMock.setSendingCalls, to: true)
        verifyEqual(videoClientMock.setMaxBitRateKbpsCalls, to: UInt32(300))
    }
    
    func testVideoClientDidReceiveEvent_ShouldPublishSignalingDroppedEvent_WhenEventTypeIsSignalingDropped() {
        let event: video_client_event = video_client_event(timestamp: 1,
                                                           event_type: VIDEO_CLIENT_EVENT_TYPE_SIGNALING_DROPPED,
                                                           signaling_dropped_error: VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_INTERNAL_SERVER_ERROR,
                                                           signaling_open_duration_ms: 0,
                                                           ice_gathering_duration_ms: 0)
                let mediaVideoClientMock = VideoClientMock()
        
        defaultVideoClientController.videoClient(mediaVideoClientMock, didReceive: event)
        
        let captured = verify(eventAnalyticsControllerMock.publishEventCalls) {
            $0.name == .videoClientSignalingDropped
        }
        
        let error = captured?.attributes?[EventAttributeName.signalingDroppedError] as? SignalingDroppedError
        XCTAssertEqual(error, SignalingDroppedError.internalServerError)
    }
    
    func testVideoClientDidReceiveEvent_ShouldPublishSignalingOpenedEvent_WhenEventTypeIsSignalingOpened() {
        let event: video_client_event = video_client_event(timestamp: 1,
                                                           event_type: VIDEO_CLIENT_EVENT_TYPE_SIGNALING_OPENED,
                                                           signaling_dropped_error: VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_INTERNAL_SERVER_ERROR,
                                                           signaling_open_duration_ms: 123,
                                                           ice_gathering_duration_ms: 0)
                let mediaVideoClientMock = VideoClientMock()
        
        defaultVideoClientController.videoClient(mediaVideoClientMock, didReceive: event)
        
        let captured = verify(eventAnalyticsControllerMock.publishEventCalls) { $0.name == .videoClientSignalingOpened }
        
        let duration = captured?.attributes?[EventAttributeName.signalingOpenDurationMs] as? Int64
        XCTAssertEqual(duration, 123)
    }
    
    func testVideoClientDidReceiveEvent_ShouldPublishIceGatheringCompleted_WhenEventTypeIsIceGatheringCompleted() {
        let event: video_client_event = video_client_event(timestamp: 1,
                                                           event_type: VIDEO_CLIENT_EVENT_TYPE_ICE_GATHERING_COMPLETED,
                                                           signaling_dropped_error: VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_INTERNAL_SERVER_ERROR,
                                                           signaling_open_duration_ms: 123,
                                                           ice_gathering_duration_ms: 456)
                let mediaVideoClientMock = VideoClientMock()
        
        defaultVideoClientController.videoClient(mediaVideoClientMock, didReceive: event)
        
        let captured = verify(eventAnalyticsControllerMock.publishEventCalls) {
            $0.name == .videoClientIceGatheringCompleted
        }
        
        let duration = captured?.attributes?[EventAttributeName.iceGatheringDurationMs] as? Int64
        XCTAssertEqual(duration, 456)
    }
}
