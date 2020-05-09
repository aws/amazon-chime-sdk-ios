//
//  MediaErrorTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class MediaErrorTests: XCTestCase {
    func testDescriptionShouldMatch() {
        XCTAssertEqual(MediaError.illegalState.description, "illegalState")
    }
}
