//
//  VoiceFocusErrorTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class VoiceFocusErrorTests: XCTestCase {
    
    func testInitFromXalErrorShouldReturnMatchingError() {
        XCTAssertEqual(VoiceFocusError.init(from: 1), VoiceFocusError.audioClientError)
        XCTAssertEqual(VoiceFocusError.init(from: 6), VoiceFocusError.notInitialized)
        XCTAssertEqual(VoiceFocusError.init(from: 19), VoiceFocusError.setParamFailed)
        XCTAssertEqual(VoiceFocusError.init(from: 99), VoiceFocusError.other)
    }
    
    func testDescriptionShouldMatch() {
        XCTAssertEqual(VoiceFocusError.audioClientNotStarted.description, "audioClientNotStarted")
        XCTAssertEqual(VoiceFocusError.audioClientError.description, "audioClientError")
        XCTAssertEqual(VoiceFocusError.setParamFailed.description, "setParamFailed")
        XCTAssertEqual(VoiceFocusError.notInitialized.description, "notInitialized")
        XCTAssertEqual(VoiceFocusError.other.description, "other")
    }
}
