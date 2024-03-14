//
//  AudioModeTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//
@testable import AmazonChimeSDK
import XCTest

class AudioModeTests: XCTestCase {
    func testDescriptionShouldMatch() {
        XCTAssertEqual(AudioMode.mono16K.description, "mono16K")
        XCTAssertEqual(AudioMode.mono48K.description, "mono48K")
        XCTAssertEqual(AudioMode.stereo48K.description, "stereo48K")
    }

    func testValidInitShouldMatchCase() {
        XCTAssertEqual(AudioMode(rawValue: 1), .mono16K)
        XCTAssertEqual(AudioMode(rawValue: 2), .mono48K)
        XCTAssertEqual(AudioMode(rawValue: 3), .stereo48K)
    }

    func testInvalidInitShouldBeNil() {
        XCTAssertNil(AudioMode(rawValue: 4))
    }
}
