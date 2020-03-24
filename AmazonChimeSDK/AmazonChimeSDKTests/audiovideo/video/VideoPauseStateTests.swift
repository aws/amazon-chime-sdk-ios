//
//  VideoPauseStateTests.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
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
