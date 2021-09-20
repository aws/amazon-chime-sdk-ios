//
//  TranscriptionStatusTypeTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class TranscriptionStatusTypeTests: XCTestCase {
    func testDescriptionShouldMatch() {
        XCTAssertEqual(TranscriptionStatusType.started.description, "started")
        XCTAssertEqual(TranscriptionStatusType.interrupted.description, "interrupted")
        XCTAssertEqual(TranscriptionStatusType.resumed.description, "resumed")
        XCTAssertEqual(TranscriptionStatusType.stopped.description, "stopped")
        XCTAssertEqual(TranscriptionStatusType.failed.description, "failed")
        XCTAssertEqual(TranscriptionStatusType.unknown.description, "unknown")
    }
}
