//
//  PermissionErrorTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class PermissionErrorTests: XCTestCase {
    func testDescriptionShouldMatch() {
        XCTAssertEqual(PermissionError.audioPermissionError.description, "audioPermissionError")
        XCTAssertEqual(PermissionError.videoPermissionError.description, "videoPermissionError")
    }
}
