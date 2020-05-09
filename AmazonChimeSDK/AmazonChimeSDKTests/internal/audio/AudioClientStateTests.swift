//
//  AudioClientStateTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class AudioClientStateTests: XCTestCase {
    func testDescriptionShouldMatch() {
        XCTAssertEqual(AudioClientState.initialized.description, "initialized")
        XCTAssertEqual(AudioClientState.started.description, "started")
        XCTAssertEqual(AudioClientState.stopped.description, "stopped")
    }
}
