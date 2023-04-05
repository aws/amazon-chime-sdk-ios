//
//  DateUtilsTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@testable import AmazonChimeSDK
import XCTest

class DateUtilsTests: XCTestCase {
    func testGetClientUtcOffsetForPositiveUtcOffsetSeconds() {
        XCTAssertEqual(DateUtils.getFormattedUtcOffset(offsetSeconds: 3600), "+01:00")
    }

    func testGetClientUtcOffsetForNegativeUtcOffsetSeconds() {
        XCTAssertEqual(DateUtils.getFormattedUtcOffset(offsetSeconds: -3600), "-01:00")
    }
}
