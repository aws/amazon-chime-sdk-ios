//
//  ConsoleLoggerTest.swift
//  AmazonChimeSDKTests
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

@testable import AmazonChimeSDK
import XCTest

class ConsoleLoggerTests: XCTestCase {

    func testConsoleLoggerShouldBeInitialized() {
        let logger = ConsoleLogger(name: "logger")
        XCTAssertEqual(LogLevel.DEFAULT, logger.getLogLevel())
    }

    func testConsoleLoggerShouldBeSetLogLevelWhenBeingInitializedWithGivenLevel() {
        let logger = ConsoleLogger(name: "logger", level: LogLevel.INFO)
        XCTAssertEqual(LogLevel.INFO, logger.getLogLevel())
    }

    func testsetLogLevelShouldSetLogLevelWhenGivenLogLevel() {
        let logger = ConsoleLogger(name: "logger")
        logger.setLogLevel(level: LogLevel.FAULT)
        XCTAssertEqual(LogLevel.FAULT, logger.getLogLevel())
    }

}
