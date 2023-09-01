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
        XCTAssertEqual(audioVideoConfig.enableAudioRedundancy, true)

        let audioVideoConfigAudioModeMono48K = AudioVideoConfiguration(audioMode: .mono48K)
        XCTAssertEqual(audioVideoConfigAudioModeMono48K.audioMode, .mono48K)
        XCTAssertEqual(audioVideoConfigAudioModeMono48K.callKitEnabled, false)
        XCTAssertEqual(audioVideoConfig.enableAudioRedundancy, true)

        let audioVideoConfigAudioModeMono16K = AudioVideoConfiguration(audioMode: .mono16K)
        XCTAssertEqual(audioVideoConfigAudioModeMono16K.audioMode, .mono16K)
        XCTAssertEqual(audioVideoConfigAudioModeMono16K.callKitEnabled, false)
        XCTAssertEqual(audioVideoConfig.enableAudioRedundancy, true)

        let audioVideoConfigCallkit = AudioVideoConfiguration(callKitEnabled: true)
        XCTAssertEqual(audioVideoConfigCallkit.audioMode, .stereo48K)
        XCTAssertEqual(audioVideoConfigCallkit.callKitEnabled, true)
        XCTAssertEqual(audioVideoConfig.enableAudioRedundancy, true)

        let audioVideoConfigAudioModeNoDevice = AudioVideoConfiguration(audioMode: .nodevice)
        XCTAssertEqual(audioVideoConfigAudioModeNoDevice.audioMode, .nodevice)
        XCTAssertEqual(audioVideoConfigAudioModeNoDevice.callKitEnabled, false)
        XCTAssertEqual(audioVideoConfig.enableAudioRedundancy, true)

        let audioVideoConfigAudioModeNoDevice = AudioVideoConfiguration(enableAudioRedundancy: false)
        XCTAssertEqual(audioVideoConfigAudioModeNoDevice.audioMode, .stereo48K)
        XCTAssertEqual(audioVideoConfigAudioModeNoDevice.callKitEnabled, false)
        XCTAssertEqual(audioVideoConfig.enableAudioRedundancy, false)


    }
}
