//
//  LogLevelTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
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
