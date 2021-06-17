//
//  IngestionConfigurationTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class IngestionConfigurationTests: XCTestCase {
    private let clientConfigurationMock = MeetingEventClientConfiguration(eventClientJoinToken: "", meetingId: "meetingId", attendeeId: "attendeeId")
    private let ingestionUrl = ""
    private let disabled = false
    private let bufferSize = 50
    private let flushSize = 20
    private let flushIntervalMs = Int64(500)
    private let retryCountLimit = 2

    func testIngestionConfigurationShouldBeInitialized() {
        let ingestionConfiguration = IngestionConfiguration(clientConfiguration: clientConfigurationMock,
                                                            ingestionUrl: ingestionUrl,
                                                            disabled: disabled,
                                                            flushSize: flushSize,
                                                            flushIntervalMs: flushIntervalMs,
                                                            retryCountLimit: retryCountLimit)

        XCTAssertEqual(ingestionUrl, ingestionConfiguration.ingestionUrl)
        XCTAssertEqual(disabled, ingestionConfiguration.disabled)
        XCTAssertEqual(flushSize, ingestionConfiguration.flushSize)
        XCTAssertEqual(flushIntervalMs, ingestionConfiguration.flushIntervalMs)
        XCTAssertEqual(retryCountLimit, ingestionConfiguration.retryCountLimit)
    }

    func testIngestionConfigurationShouldDefaultToCertainValueWhenNegative() {
        let ingestionConfiguration = IngestionConfiguration(clientConfiguration: clientConfigurationMock,
                                                            ingestionUrl: ingestionUrl,
                                                            disabled: disabled,
                                                            flushSize: -1,
                                                            flushIntervalMs: -1,
                                                            retryCountLimit: -1)

        XCTAssertGreaterThan(ingestionConfiguration.flushSize, 0)
        XCTAssertGreaterThan(ingestionConfiguration.flushIntervalMs, 0)
        XCTAssertGreaterThan(ingestionConfiguration.retryCountLimit, 0)
    }

    func testIngestionConfigurationShouldDefaultToCertainValueWhenGivenValuesAreLarge() {
        let largeValue = 1000000000
        let ingestionConfiguration = IngestionConfiguration(clientConfiguration: clientConfigurationMock,
                                                            ingestionUrl: ingestionUrl,
                                                            disabled: disabled,
                                                            flushSize: largeValue,
                                                            flushIntervalMs: Int64(largeValue),
                                                            retryCountLimit: largeValue)

        XCTAssertLessThan(ingestionConfiguration.flushSize, largeValue)
        XCTAssertLessThan(ingestionConfiguration.retryCountLimit, largeValue)
    }
}
