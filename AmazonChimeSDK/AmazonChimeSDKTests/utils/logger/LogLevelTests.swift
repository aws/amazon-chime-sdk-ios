//
//  LogLevelTests.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

@testable import AmazonChimeSDK
import XCTest

class LogLevelTests: XCTestCase {
    func testDescriptionShouldMatch() {
        XCTAssertEqual(LogLevel.DEFAULT.description, "DEFAULT")
        XCTAssertEqual(LogLevel.DEBUG.description, "DEBUG")
        XCTAssertEqual(LogLevel.INFO.description, "INFO")
        XCTAssertEqual(LogLevel.FAULT.description, "FAULT")
        XCTAssertEqual(LogLevel.ERROR.description, "ERROR")
        XCTAssertEqual(LogLevel.OFF.description, "OFF")
    }
}
