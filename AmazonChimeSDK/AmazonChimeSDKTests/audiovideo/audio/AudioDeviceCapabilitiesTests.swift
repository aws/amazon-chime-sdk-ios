//
//  AudioDeviceCapabilitiesTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//
@testable import AmazonChimeSDK
import XCTest

class AudioDeviceCapabilitiesTests: XCTestCase {
    func testDescriptionShouldMatch() {
        XCTAssertEqual(AudioDeviceCapabilities.none.description, "none")
        XCTAssertEqual(AudioDeviceCapabilities.outputOnly.description, "outputOnly")
        XCTAssertEqual(AudioDeviceCapabilities.inputAndOutput.description, "inputAndOutput")
    }
}
