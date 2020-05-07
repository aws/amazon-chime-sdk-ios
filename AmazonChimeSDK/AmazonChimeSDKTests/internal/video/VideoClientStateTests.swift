//
//  VideoClientStateTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class VideoClientStateTests: XCTestCase {
    func testDescriptionShouldMatch() {
        XCTAssertEqual(VideoClientState.uninitialized.description, "uninitialized")
        XCTAssertEqual(VideoClientState.initialized.description, "initialized")
        XCTAssertEqual(VideoClientState.started.description, "started")
        XCTAssertEqual(VideoClientState.stopped.description, "stopped")
    }
}
