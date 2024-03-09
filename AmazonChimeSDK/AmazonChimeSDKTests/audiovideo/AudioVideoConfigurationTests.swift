//
//  AudioVideoConfigurationTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class AudioVideoConfigurationTests: XCTestCase {
    func testDefaultConfigurations() {
        let audioVideoConfig = AudioVideoConfiguration()
        XCTAssertEqual(audioVideoConfig.audioMode, .stereo48K)
        XCTAssertEqual(audioVideoConfig.audioDeviceCapabilities, .inputAndOutput)
        XCTAssertEqual(audioVideoConfig.callKitEnabled, false)
        XCTAssertEqual(audioVideoConfig.enableAudioRedundancy, true)
        XCTAssertEqual(audioVideoConfig.videoMaxResolution, .videoResolutionHD)
    }
}
