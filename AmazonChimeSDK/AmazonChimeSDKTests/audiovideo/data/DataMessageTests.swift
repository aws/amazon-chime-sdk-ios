//
//  DataMessageTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class DataMessageTests: XCTestCase {

    let topic = "AValidTopic"
    let data = Data()
    let senderAttendeeId = "123456"
    let senderExternalAttendeeId = "1234#external"

    func testDataMessageShouldBeInitialized() {
        let dataMessage = DataMessage(topic: topic,
                                      data: data,
                                      senderAttendeeId: senderAttendeeId,
                                      senderExternalUserId: senderExternalAttendeeId,
                                      timestampMs: 1,
                                      throttled: false)

        XCTAssertEqual(topic, dataMessage.topic)
        XCTAssertEqual(data, dataMessage.data)
        XCTAssertEqual(senderAttendeeId, dataMessage.senderAttendeeId)
        XCTAssertEqual(senderExternalAttendeeId, dataMessage.senderExternalUserId)
        XCTAssertEqual(1, dataMessage.timestampMs)
        XCTAssertEqual(false, dataMessage.throttled)
    }

    func testDataMessageText() {
        let anotherString = "AnotherString"

        let dataMessage = DataMessage(topic: topic,
                                      data: anotherString.data(using: .utf8, allowLossyConversion: true)!,
                                      senderAttendeeId: senderAttendeeId,
                                      senderExternalUserId: senderExternalAttendeeId,
                                      timestampMs: 1,
                                      throttled: false)
        XCTAssertEqual(anotherString, dataMessage.text())
    }

    func testDataMessageTextNil() {
        var data = Data()
        data.append(contentsOf: [255, 255])
        let dataMessage = DataMessage(topic: topic,
                                      data: data,
                                      senderAttendeeId: senderAttendeeId,
                                      senderExternalUserId: senderExternalAttendeeId,
                                      timestampMs: 1,
                                      throttled: false)
        XCTAssertNil(dataMessage.text())
    }

    func testDataMessageFromJSON() {
        let anotherString = "{\"ABC\":\"CBA\"}"
        let jsonObject = ["ABC": "CBA"]
        let dataMessage = DataMessage(topic: topic,
                                      data: anotherString.data(using: .utf8, allowLossyConversion: true)!,
                                      senderAttendeeId: senderAttendeeId,
                                      senderExternalUserId: senderExternalAttendeeId,
                                      timestampMs: 1,
                                      throttled: false)
        let returnJson = dataMessage.fromJSON() as? [String: String]
        XCTAssertEqual(jsonObject, returnJson)
    }

    func testDataMessageFromJSONNil() {
        let anotherString = "AnotherString"

        let dataMessage = DataMessage(topic: topic,
                                      data: anotherString.data(using: .utf8, allowLossyConversion: true)!,
                                      senderAttendeeId: senderAttendeeId,
                                      senderExternalUserId: senderExternalAttendeeId,
                                      timestampMs: 1,
                                      throttled: false)
        XCTAssertNil(dataMessage.fromJSON())
    }
}
