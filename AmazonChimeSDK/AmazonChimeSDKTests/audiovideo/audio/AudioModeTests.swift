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
        XCTAssertEqual(AudioMode.mono.description, "mono")
        XCTAssertEqual(AudioMode.noAudio.description, "noAudio")
    }
}
