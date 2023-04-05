//
//  TimezoneUtilsTest.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@testable import AmazonChimeSDK
import XCTest

class TimezoneUtilsTest: XCTestCase {
    func testGetClientUtcOffsetForPositiveUtcOffsetSeconds() {
        XCTAssertEqual(TimezoneUtils.getClientUtcOffset(offsetSeconds: 3600), "+01:00")
    }

    func testGetClientUtcOffsetForNegativeUtcOffsetSeconds() {
        XCTAssertEqual(TimezoneUtils.getClientUtcOffset(offsetSeconds: -3600), "-01:00")
    }
}
