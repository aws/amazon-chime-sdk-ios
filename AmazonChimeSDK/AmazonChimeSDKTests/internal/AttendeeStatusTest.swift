//
//  AttendeeStatusTest.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class AttendeeStatusTests: XCTestCase {
    func testDescriptionShouldMatch() {
        XCTAssertEqual(AttendeeStatus.joined.description, "joined")
        XCTAssertEqual(AttendeeStatus.left.description, "left")
        XCTAssertEqual(AttendeeStatus.dropped.description, "dropped")
    }
}
