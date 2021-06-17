//
//  IngestionConfigurationBuilderTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class IngestionConfigurationBuilderTests: XCTestCase {
    private let clientConfigurationMock = MeetingEventClientConfiguration(eventClientJoinToken: "", meetingId: "meetingId", attendeeId: "attendeeId")
    private let ingestionUrl = "url"
    private let disabled = false
    private let bufferSize = 10
    private let flushSize = 10
    private let flushIntervalMs = Int64(500)
    private let retryCountLimit = 1

    func testIngestionConfigurationBuilderShouldBeAbleToInitializedIngestionConfiguration() {
        let ingestionConfiguration = IngestionConfigurationBuilder()
            .setFlushIntervalMs(flushIntervalMs: flushIntervalMs)
            .setFlushSize(flushSize: flushSize)
            .setRetryCountLimit(retryCountLimit: retryCountLimit)
            .build(disabled: true, ingestionUrl: ingestionUrl, clientConiguration: clientConfigurationMock)

        XCTAssertNotNil(ingestionConfiguration)
        XCTAssertEqual(ingestionUrl, ingestionConfiguration.ingestionUrl)
        XCTAssertEqual(true, ingestionConfiguration.disabled)
        XCTAssertEqual(flushSize, ingestionConfiguration.flushSize)
        XCTAssertEqual(flushIntervalMs, ingestionConfiguration.flushIntervalMs)
        XCTAssertEqual(retryCountLimit, ingestionConfiguration.retryCountLimit)
    }

    func testIngestionConfigurationBuilderShouldReturnNilIfIngestionUrlOrClientConfigurationIsNotPassed() {
        let ingestionConfiguration = IngestionConfigurationBuilder().build(disabled: true,
                                                                           ingestionUrl: ingestionUrl,
                                                                           clientConiguration: clientConfigurationMock)

        XCTAssertNotNil(ingestionConfiguration)
    }

    func testIngestionConfigurationShouldDefaultSomeValuesForOptionalParameters() {
        let ingestionConfiguration = IngestionConfigurationBuilder().build(disabled: false, ingestionUrl: ingestionUrl,
                                                                           clientConiguration: clientConfigurationMock)

        XCTAssertGreaterThan(ingestionConfiguration.flushSize, 0)
        XCTAssertGreaterThan(ingestionConfiguration.retryCountLimit, 0)
        XCTAssertEqual(ingestionConfiguration.disabled, false)
        XCTAssertGreaterThan(ingestionConfiguration.flushIntervalMs, 0)
    }
}
