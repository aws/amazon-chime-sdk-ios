//
//  CaptureSourceErrorTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class CaptureSourceErrorTests: XCTestCase {
    func testDescriptionShouldMatch() {
        XCTAssertEqual(CaptureSourceError.unknown.description, "unknown")
        XCTAssertEqual(CaptureSourceError.systemFailure.description, "systemFailure")
        XCTAssertEqual(CaptureSourceError.configurationFailure.description, "configurationFailure")
        XCTAssertEqual(CaptureSourceError.invalidFrame.description, "invalidFrame")
    }
}
