//
//  TranscriptItemTypeTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class TranscriptItemTypeTests: XCTestCase {
    func testDescriptionShouldMatch() {
        XCTAssertEqual(TranscriptItemType.pronunciation.description, "pronunciation")
        XCTAssertEqual(TranscriptItemType.punctuation.description, "punctuation")
        XCTAssertEqual(TranscriptItemType.unknown.description, "unknown")
    }
}
