//
//  DefaultVideoClientControllerTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import AmazonChimeSDKMedia
import Cuckoo
import XCTest

class DefaultVideoClientControllerTests: CommonTestCase {
    let topic = "topic"
    let testMessage = "test"

    var videoClientMock: MockVideoClientProtocol!
    var clientMetricsCollectorMock: MockClientMetricsCollector!
    var eventAnalyticsControllerMock: MockEventAnalyticsController!
    var videoSourceMock: MockVideoSource!

    var defaultVideoClientController: DefaultVideoClientController!
    var defaultVideoClientControllerNone: DefaultVideoClientController!
    var defaultVideoClientControllerHigh: DefaultVideoClientController!

    override func setUp() {
        super.setUp()

        videoSourceMock = MockVideoSource().withEnabledDefaultImplementation(VideoSourceStub())
        videoClientMock = MockVideoClientProtocol().withEnabledDefaultImplementation(VideoClientProtocolStub())
        clientMetricsCollectorMock = MockClientMetricsCollector().withEnabledDefaultImplementation(ClientMetricsCollectorStub())
        eventAnalyticsControllerMock = MockEventAnalyticsController().withEnabledDefaultImplementation(EventAnalyticsControllerStub())

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
        stub(videoSourceMock) { stub in
            when(stub.videoContentHint.get).thenReturn(VideoContentHint.text)
        }
    }

    func testSendDataMessage_videoClientNotStarted() {
        XCTAssertNoThrow(try defaultVideoClientController.sendDataMessage(topic: topic, data: testMessage))

        verify(loggerMock).error(msg: "Cannot send data message because videoClientState=uninitialized")
        verify(videoClientMock, never()).sendDataMessage(any(), data: any(), dataLen: any(), lifetimeMs: any())
    }

    func testSendDataMessage_negativeLifetimeMs() {
        defaultVideoClientController.start()
        XCTAssertThrowsError(try defaultVideoClientController.sendDataMessage(topic: topic, data: testMessage, lifetimeMs: -1)) { error in
            XCTAssertEqual(error as? SendDataMessageError, SendDataMessageError.negativeLifetimeParameter)
        }

        verify(videoClientMock, never()).sendDataMessage(any(), data: any(), dataLen: any(), lifetimeMs: any())
    }

    func testSendDataMessage_invalidTopic() {
        defaultVideoClientController.start()
        XCTAssertThrowsError(try defaultVideoClientController.sendDataMessage(topic: "$invalid$", data: testMessage)) { error in
            XCTAssertEqual(error as? SendDataMessageError, SendDataMessageError.invalidTopic)
        }

        verify(videoClientMock, never()).sendDataMessage(any(), data: any(), dataLen: any(), lifetimeMs: any())
    }

    func testSendDataMessage_sendString() {
        defaultVideoClientController.start()
        XCTAssertNoThrow(try defaultVideoClientController.sendDataMessage(topic: topic, data: testMessage))

        verify(videoClientMock).sendDataMessage(self.topic, data: any(), dataLen: any(), lifetimeMs: Int32(0))
    }

    func testSendDataMessage_sendByteArray() {
        defaultVideoClientController.start()
        XCTAssertNoThrow(try defaultVideoClientController.sendDataMessage(topic: topic, data: [116, 101, 115, 116]))

        verify(videoClientMock).sendDataMessage(self.topic, data: any(), dataLen: any(), lifetimeMs: Int32(0))
    }

    func testSendDataMessage_sendJson() {
        defaultVideoClientController.start()
        XCTAssertNoThrow(try defaultVideoClientController.sendDataMessage(topic: topic, data: ["key": "value"]))

        verify(videoClientMock).sendDataMessage(self.topic, data: any(), dataLen: any(), lifetimeMs: Int32(0))
    }

    func testSendDataMessage_sendInvalidData() {
        defaultVideoClientController.start()
        XCTAssertThrowsError(try defaultVideoClientController.sendDataMessage(topic: topic, data: 0)) { error in
            XCTAssertEqual(error as? SendDataMessageError, SendDataMessageError.invalidData)
        }

        verify(videoClientMock, never()).sendDataMessage(self.topic, data: any(), dataLen: any(), lifetimeMs: Int32(0))
    }

    func testSendLocalVideo() {
        defaultVideoClientController.start()
        XCTAssertNoThrow(try defaultVideoClientController.startLocalVideo())

        verify(videoClientMock).setExternalVideoSource(any())
        verify(videoClientMock).setSending(true)
    }

    func testSendLocalVideoNone() {
        defaultVideoClientControllerNone.start()
        XCTAssertNoThrow(try defaultVideoClientControllerNone.startLocalVideo())

        verify(videoClientMock, never()).setExternalVideoSource(any())
        verify(videoClientMock, never()).setSending(true)
    }

    func testSendLocalVideoHigh() {
        defaultVideoClientControllerHigh.start()
        XCTAssertNoThrow(try defaultVideoClientControllerHigh.startLocalVideo())

        verify(videoClientMock).setExternalVideoSource(any())
        verify(videoClientMock).setMaxBitRateKbps(VideoBitrateConstants().videoHighResolutionBitrateKbps)
        verify(videoClientMock).setSending(true)
    }

    func testSendLocalVideoWithConfig() {
        defaultVideoClientController.start()
        let config = LocalVideoConfiguration(maxBitRateKbps: 300)
        XCTAssertNoThrow(try defaultVideoClientController.startLocalVideo(config: config))

        verify(videoClientMock).setExternalVideoSource(any())
        verify(videoClientMock).setSending(true)
        verify(videoClientMock).setMaxBitRateKbps(UInt32(300))
    }

    func testSendLocalVideoWithSource() {
        defaultVideoClientController.start()
        defaultVideoClientController.startLocalVideo(source: videoSourceMock)

        verify(videoClientMock).setExternalVideoSource(any())
        verify(videoClientMock).setSending(true)
    }

    func testSendLocalVideoWithSourceAndConfig() {
        defaultVideoClientController.start()
        let config = LocalVideoConfiguration(maxBitRateKbps: 300)
        defaultVideoClientController.startLocalVideo(source: videoSourceMock, config: config)

        verify(videoClientMock).setExternalVideoSource(any())
        verify(videoClientMock).setSending(true)
        verify(videoClientMock).setMaxBitRateKbps(UInt32(300))
    }
    
    func testVideoClientDidReceiveEvent_ShouldPublishSignalingDroppedEvent_WhenEventTypeIsSignalingDropped() {
        let event: video_client_event = video_client_event(timestamp: 1,
                                                           event_type: VIDEO_CLIENT_EVENT_TYPE_SIGNALING_DROPPED,
                                                           signaling_dropped_error: VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_INTERNAL_SERVER_ERROR,
                                                           signaling_open_duration_ms: 0,
                                                           ice_gathering_duration_ms: 0)
        let captor = ArgumentCaptor<[AnyHashable: Any]>()
        
        let mediaVideoClientMock = VideoClientMock()
        
        defaultVideoClientController.videoClient(mediaVideoClientMock, didReceive: event)
        
        verify(eventAnalyticsControllerMock).publishEvent(name: equal(to: .videoClientSignalingDropped),
                                                          attributes: captor.capture())
        
        let error = captor.value?[EventAttributeName.signalingDroppedError] as? SignalingDroppedError
        XCTAssertEqual(error, SignalingDroppedError.internalServerError)
    }
    
    func testVideoClientDidReceiveEvent_ShouldPublishSignalingOpenedEvent_WhenEventTypeIsSignalingOpened() {
        let event: video_client_event = video_client_event(timestamp: 1,
                                                           event_type: VIDEO_CLIENT_EVENT_TYPE_SIGNALING_OPENED,
                                                           signaling_dropped_error: VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_INTERNAL_SERVER_ERROR,
                                                           signaling_open_duration_ms: 123,
                                                           ice_gathering_duration_ms: 0)
        let captor = ArgumentCaptor<[AnyHashable: Any]>()
        
        let mediaVideoClientMock = VideoClientMock()
        
        defaultVideoClientController.videoClient(mediaVideoClientMock, didReceive: event)
        
        verify(eventAnalyticsControllerMock).publishEvent(name: equal(to: .videoClientSignalingOpened),
                                                          attributes: captor.capture())
        
        let duration = captor.value?[EventAttributeName.signalingOpenDurationMs] as? Int64
        XCTAssertEqual(duration, 123)
    }
    
    func testVideoClientDidReceiveEvent_ShouldPublishIceGatheringCompleted_WhenEventTypeIsIceGatheringCompleted() {
        let event: video_client_event = video_client_event(timestamp: 1,
                                                           event_type: VIDEO_CLIENT_EVENT_TYPE_ICE_GATHERING_COMPLETED,
                                                           signaling_dropped_error: VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_INTERNAL_SERVER_ERROR,
                                                           signaling_open_duration_ms: 123,
                                                           ice_gathering_duration_ms: 456)
        let captor = ArgumentCaptor<[AnyHashable: Any]>()
        
        let mediaVideoClientMock = VideoClientMock()
        
        defaultVideoClientController.videoClient(mediaVideoClientMock, didReceive: event)
        
        verify(eventAnalyticsControllerMock).publishEvent(name: equal(to: .videoClientIceGatheringCompleted),
                                                          attributes: captor.capture())
        
        let duration = captor.value?[EventAttributeName.iceGatheringDurationMs] as? Int64
        XCTAssertEqual(duration, 456)
    }
}
