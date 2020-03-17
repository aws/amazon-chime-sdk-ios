//
//  SignalStrengthTests.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
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
