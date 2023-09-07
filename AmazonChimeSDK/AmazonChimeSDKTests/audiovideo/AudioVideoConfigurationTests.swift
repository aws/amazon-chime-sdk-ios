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
        XCTAssertEqual(audioVideoConfig.callKitEnabled, false)
        XCTAssertEqual(audioVideoConfig.enableAudioRedundancy, true)

        let audioVideoConfigAudioMode = AudioVideoConfiguration(audioMode: .stereo48K)
        XCTAssertEqual(audioVideoConfigAudioMode.audioMode, .stereo48K)
        XCTAssertEqual(audioVideoConfigAudioMode.callKitEnabled, false)
        XCTAssertEqual(audioVideoConfigAudioMode.enableAudioRedundancy, true)

        let audioVideoConfigAudioModeMono48K = AudioVideoConfiguration(audioMode: .mono48K)
        XCTAssertEqual(audioVideoConfigAudioModeMono48K.audioMode, .mono48K)
        XCTAssertEqual(audioVideoConfigAudioModeMono48K.callKitEnabled, false)
        XCTAssertEqual(audioVideoConfigAudioModeMono48K.enableAudioRedundancy, true)

        let audioVideoConfigAudioModeMono16K = AudioVideoConfiguration(audioMode: .mono16K)
        XCTAssertEqual(audioVideoConfigAudioModeMono16K.audioMode, .mono16K)
        XCTAssertEqual(audioVideoConfigAudioModeMono16K.callKitEnabled, false)
        XCTAssertEqual(audioVideoConfigAudioModeMono16K.enableAudioRedundancy, true)

        let audioVideoConfigCallkit = AudioVideoConfiguration(callKitEnabled: true)
        XCTAssertEqual(audioVideoConfigCallkit.audioMode, .stereo48K)
        XCTAssertEqual(audioVideoConfigCallkit.callKitEnabled, true)
        XCTAssertEqual(audioVideoConfigCallkit.enableAudioRedundancy, true)

        let audioVideoConfigAudioModeNoDevice = AudioVideoConfiguration(audioMode: .nodevice)
        XCTAssertEqual(audioVideoConfigAudioModeNoDevice.audioMode, .nodevice)
        XCTAssertEqual(audioVideoConfigAudioModeNoDevice.callKitEnabled, false)
        XCTAssertEqual(audioVideoConfigAudioModeNoDevice.enableAudioRedundancy, true)

        let audioVideoConfigRedundancyDisabled = AudioVideoConfiguration(enableAudioRedundancy: false)
        XCTAssertEqual(audioVideoConfigRedundancyDisabled.audioMode, .stereo48K)
        XCTAssertEqual(audioVideoConfigRedundancyDisabled.callKitEnabled, false)
        XCTAssertEqual(audioVideoConfigRedundancyDisabled.enableAudioRedundancy, false)
    }
}
