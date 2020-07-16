//
//  ConsoleLoggerTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class ConsoleLoggerTests: XCTestCase {
    private var logger: ConsoleLogger?

    override func setUp() {
        logger = ConsoleLogger(name: "logger")
    }

    func testConsoleLoggerShouldBeInitialized() {
        XCTAssertEqual(LogLevel.DEFAULT, logger?.getLogLevel())
    }

    func testConsoleLoggerShouldBeSetLogLevelWhenBeingInitializedWithGivenLevel() {
        logger = ConsoleLogger(name: "logger", level: LogLevel.INFO)
        XCTAssertEqual(LogLevel.INFO, logger?.getLogLevel())
    }

    func testsetLogLevelShouldSetLogLevelWhenGivenLogLevel() {
        logger?.setLogLevel(level: LogLevel.FAULT)
        XCTAssertEqual(LogLevel.FAULT, logger?.getLogLevel())
    }
}
