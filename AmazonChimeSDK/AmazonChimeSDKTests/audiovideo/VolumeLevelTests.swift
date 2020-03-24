//
//  VolumeLevelTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class VolumeLevelTests: XCTestCase {
    func testDescriptionShouldMatch() {
        XCTAssertEqual(VolumeLevel.muted.description, "muted")
        XCTAssertEqual(VolumeLevel.notSpeaking.description, "notSpeaking")
        XCTAssertEqual(VolumeLevel.low.description, "low")
        XCTAssertEqual(VolumeLevel.medium.description, "medium")
        XCTAssertEqual(VolumeLevel.high.description, "high")
    }
}
