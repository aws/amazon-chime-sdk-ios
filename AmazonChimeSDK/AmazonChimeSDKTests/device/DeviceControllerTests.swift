//
//  DeviceControllerTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import AVFoundation
import XCTest

class DeviceControllerTests: XCTestCase {
    func testListDevicesReturnsSpeakerWithCorrectType() {
        let audioSession = MockAudioSession()
        let videoClient = MockVideoClientController()
        let logger = ConsoleLogger(name: "logger")

        let controller = DefaultDeviceController(audioSession: audioSession, videoClientController: videoClient, logger: logger)
        let devices = controller.listAudioDevices()
        let secondDevice = devices[1]

        XCTAssertEqual(secondDevice.type, MediaDeviceType.audioBuiltInSpeaker)
    }
}
