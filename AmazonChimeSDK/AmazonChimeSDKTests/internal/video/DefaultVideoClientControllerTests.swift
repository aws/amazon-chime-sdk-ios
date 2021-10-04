//
//  DefaultVideoClientControllerTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import AmazonChimeSDKMedia
import Mockingbird
import XCTest

class DefaultVideoClientControllerTests: CommonTestCase {
    let topic = "topic"
    let testMessage = "test"

    var videoClientMock: VideoClientProtocolMock!
    var clientMetricsCollectorMock: ClientMetricsCollectorMock!
    var eventAnalyticsControllerMock: EventAnalyticsControllerMock!

    var defaultVideoClientController: DefaultVideoClientController!

    override func setUp() {
        super.setUp()

        videoClientMock = mock(VideoClientProtocol.self)
        clientMetricsCollectorMock = mock(ClientMetricsCollector.self)
        eventAnalyticsControllerMock = mock(EventAnalyticsController.self)

        defaultVideoClientController = DefaultVideoClientController(videoClient: videoClientMock,
                                                                    clientMetricsCollector: clientMetricsCollectorMock,
                                                                    configuration: meetingSessionConfigurationMock,
                                                                    logger: loggerMock,
                                                                    eventAnalyticsController: eventAnalyticsControllerMock)
    }

    func testSendDataMessage_videoClientNotStarted() {
        XCTAssertNoThrow(try defaultVideoClientController.sendDataMessage(topic: topic, data: testMessage))

        verify(loggerMock.error(msg: "Cannot send data message because videoClientState=uninitialized")).wasCalled()
        verify(videoClientMock.sendDataMessage(any(), data: any(), lifetimeMs: any())).wasNeverCalled()
    }

    func testSendDataMessage_negativeLifetimeMs() {
        defaultVideoClientController.start()
        XCTAssertThrowsError(try defaultVideoClientController.sendDataMessage(topic: topic, data: testMessage, lifetimeMs: -1)) { error in
            XCTAssertEqual(error as? SendDataMessageError, SendDataMessageError.negativeLifetimeParameter)
        }

        verify(videoClientMock.sendDataMessage(any(), data: any(), lifetimeMs: any())).wasNeverCalled()
    }

    func testSendDataMessage_invalidTopic() {
        defaultVideoClientController.start()
        XCTAssertThrowsError(try defaultVideoClientController.sendDataMessage(topic: "$invalid$", data: testMessage)) { error in
            XCTAssertEqual(error as? SendDataMessageError, SendDataMessageError.invalidTopic)
        }

        verify(videoClientMock.sendDataMessage(any(), data: any(), lifetimeMs: any())).wasNeverCalled()
    }

    func testSendDataMessage_sendString() {
        defaultVideoClientController.start()
        XCTAssertNoThrow(try defaultVideoClientController.sendDataMessage(topic: topic, data: testMessage))

        verify(videoClientMock.sendDataMessage(self.topic, data: any(), lifetimeMs: 0)).wasCalled()
    }

    func testSendDataMessage_sendByteArray() {
        defaultVideoClientController.start()
        XCTAssertNoThrow(try defaultVideoClientController.sendDataMessage(topic: topic, data: [116, 101, 115, 116]))

        verify(videoClientMock.sendDataMessage(self.topic, data: any(), lifetimeMs: 0)).wasCalled()
    }

    func testSendDataMessage_sendJson() {
        defaultVideoClientController.start()
        XCTAssertNoThrow(try defaultVideoClientController.sendDataMessage(topic: topic, data: ["key": "value"]))

        verify(videoClientMock.sendDataMessage(self.topic, data: any(), lifetimeMs: 0)).wasCalled()
    }

    func testSendDataMessage_sendInvalidData() {
        defaultVideoClientController.start()
        XCTAssertThrowsError(try defaultVideoClientController.sendDataMessage(topic: topic, data: 0)) { error in
            XCTAssertEqual(error as? SendDataMessageError, SendDataMessageError.invalidData)
        }

        verify(videoClientMock.sendDataMessage(self.topic, data: any(), lifetimeMs: 0)).wasNeverCalled()
    }
}
