//
//  ContentShareStatusCodeTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class ContentShareStatusCodeTests: XCTestCase {
    func testDescriptionShouldMatch() {
        XCTAssertEqual(ContentShareStatusCode.ok.description, "ok")
        XCTAssertEqual(ContentShareStatusCode.videoServiceFailed.description, "videoServiceFailed")
    }
}
