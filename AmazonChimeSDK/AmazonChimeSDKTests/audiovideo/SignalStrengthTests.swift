//
//  SignalStrengthTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class SignalStrengthTests: XCTestCase {
    func testDescriptionShouldMatch() {
        XCTAssertEqual(SignalStrength.none.description, "none")
        XCTAssertEqual(SignalStrength.low.description, "low")
        XCTAssertEqual(SignalStrength.high.description, "high")
    }
}
