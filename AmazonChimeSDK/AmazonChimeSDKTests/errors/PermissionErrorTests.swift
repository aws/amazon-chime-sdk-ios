//
//  PermissionErrorsTests.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

@testable import AmazonChimeSDK
import XCTest

class PermissionErrorTests: XCTestCase {
    func testDescriptionShouldMatch() {
        XCTAssertEqual(PermissionError.audioPermissionError.description, "audioPermissionError")
        XCTAssertEqual(PermissionError.videoPermissionError.description, "videoPermissionError")
    }
}
