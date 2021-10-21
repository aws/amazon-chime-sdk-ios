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
        XCTAssertEqual(audioVideoConfig.audioMode, .mono)
        XCTAssertEqual(audioVideoConfig.callKitEnabled, false)

        let audioVideoConfigAudioMode = AudioVideoConfiguration(audioMode: .noAudio)
        XCTAssertEqual(audioVideoConfigAudioMode.audioMode, .noAudio)
        XCTAssertEqual(audioVideoConfigAudioMode.callKitEnabled, false)

        let audioVideoConfigCallkit = AudioVideoConfiguration(callKitEnabled: true)
        XCTAssertEqual(audioVideoConfigCallkit.audioMode, .mono)
        XCTAssertEqual(audioVideoConfigCallkit.callKitEnabled, true)
    }
}
