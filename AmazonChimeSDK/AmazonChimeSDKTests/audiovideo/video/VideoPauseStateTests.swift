//
//  VideoPauseStateTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class VideoPauseStateTests: XCTestCase {
    func testDescriptionShouldMatch() {
        XCTAssertEqual(VideoPauseState.unpaused.description, "unpaused")
        XCTAssertEqual(VideoPauseState.pausedByUserRequest.description, "pausedByUserRequest")
        XCTAssertEqual(VideoPauseState.pausedForPoorConnection.description, "pausedForPoorConnection")
    }
}
