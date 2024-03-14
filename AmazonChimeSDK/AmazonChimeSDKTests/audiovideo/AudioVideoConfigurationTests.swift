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

        let audioVideoConfigAudioMode = AudioVideoConfiguration(audioMode: .mono16K)
        XCTAssertEqual(audioVideoConfigAudioMode.audioMode, .mono16K)
        XCTAssertEqual(audioVideoConfigAudioMode.audioDeviceCapabilities, .inputAndOutput)
        XCTAssertEqual(audioVideoConfigAudioMode.callKitEnabled, false)
        XCTAssertEqual(audioVideoConfigAudioMode.enableAudioRedundancy, true)
        XCTAssertEqual(audioVideoConfigAudioMode.videoMaxResolution, .videoResolutionHD)

        let audioVideoConfigAudioDeviceCapabilities = AudioVideoConfiguration(audioDeviceCapabilities: .none)
        XCTAssertEqual(audioVideoConfigAudioDeviceCapabilities.audioMode, .stereo48K)
        XCTAssertEqual(audioVideoConfigAudioDeviceCapabilities.audioDeviceCapabilities, .none)
        XCTAssertEqual(audioVideoConfigAudioDeviceCapabilities.callKitEnabled, false)
        XCTAssertEqual(audioVideoConfigAudioDeviceCapabilities.enableAudioRedundancy, true)
        XCTAssertEqual(audioVideoConfigAudioDeviceCapabilities.videoMaxResolution, .videoResolutionHD)

        let audioVideoConfigCallKitEnabled = AudioVideoConfiguration(callKitEnabled: true)
        XCTAssertEqual(audioVideoConfigCallKitEnabled.audioMode, .stereo48K)
        XCTAssertEqual(audioVideoConfigCallKitEnabled.audioDeviceCapabilities, .inputAndOutput)
        XCTAssertEqual(audioVideoConfigCallKitEnabled.callKitEnabled, true)
        XCTAssertEqual(audioVideoConfigCallKitEnabled.enableAudioRedundancy, true)
        XCTAssertEqual(audioVideoConfigCallKitEnabled.videoMaxResolution, .videoResolutionHD)

        let audioVideoConfigEnableAudioRedundancy = AudioVideoConfiguration(enableAudioRedundancy: false)
        XCTAssertEqual(audioVideoConfigEnableAudioRedundancy.audioMode, .stereo48K)
        XCTAssertEqual(audioVideoConfigEnableAudioRedundancy.audioDeviceCapabilities, .inputAndOutput)
        XCTAssertEqual(audioVideoConfigEnableAudioRedundancy.callKitEnabled, false)
        XCTAssertEqual(audioVideoConfigEnableAudioRedundancy.enableAudioRedundancy, false)
        XCTAssertEqual(audioVideoConfigEnableAudioRedundancy.videoMaxResolution, .videoResolutionHD)

        let audioVideoConfigVideoMaxResolution = AudioVideoConfiguration(videoMaxResolution: .videoResolutionUHD)
        XCTAssertEqual(audioVideoConfigVideoMaxResolution.audioMode, .stereo48K)
        XCTAssertEqual(audioVideoConfigVideoMaxResolution.audioDeviceCapabilities, .inputAndOutput)
        XCTAssertEqual(audioVideoConfigVideoMaxResolution.callKitEnabled, false)
        XCTAssertEqual(audioVideoConfigVideoMaxResolution.enableAudioRedundancy, true)
        XCTAssertEqual(audioVideoConfigVideoMaxResolution.videoMaxResolution, .videoResolutionUHD)

        let audioVideoConfigAudioModeCallKitEnabled = AudioVideoConfiguration(audioMode: .mono16K, callKitEnabled: true)
        XCTAssertEqual(audioVideoConfigAudioModeCallKitEnabled.audioMode, .mono16K)
        XCTAssertEqual(audioVideoConfigAudioModeCallKitEnabled.audioDeviceCapabilities, .inputAndOutput)
        XCTAssertEqual(audioVideoConfigAudioModeCallKitEnabled.callKitEnabled, true)
        XCTAssertEqual(audioVideoConfigAudioModeCallKitEnabled.enableAudioRedundancy, true)
        XCTAssertEqual(audioVideoConfigAudioModeCallKitEnabled.videoMaxResolution, .videoResolutionHD)

        let audioVideoConfigAudioModeCallKitEnabledEnableAudioRedundancy = AudioVideoConfiguration(audioMode: .mono16K, callKitEnabled: true, enableAudioRedundancy: false)
        XCTAssertEqual(audioVideoConfigAudioModeCallKitEnabledEnableAudioRedundancy.audioMode, .mono16K)
        XCTAssertEqual(audioVideoConfigAudioModeCallKitEnabledEnableAudioRedundancy.audioDeviceCapabilities, .inputAndOutput)
        XCTAssertEqual(audioVideoConfigAudioModeCallKitEnabledEnableAudioRedundancy.callKitEnabled, true)
        XCTAssertEqual(audioVideoConfigAudioModeCallKitEnabledEnableAudioRedundancy.enableAudioRedundancy, false)
        XCTAssertEqual(audioVideoConfigAudioModeCallKitEnabledEnableAudioRedundancy.videoMaxResolution, .videoResolutionHD)
    }
}
