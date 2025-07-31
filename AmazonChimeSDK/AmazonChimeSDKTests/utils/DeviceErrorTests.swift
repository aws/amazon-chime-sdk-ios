//
//  DeviceErrorTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class DeviceErrorTests: XCTestCase {
    func testDescriptionShouldMatch() {
        XCTAssertEqual(DeviceError.audioPermissionError.description, "audioPermissionError")
        XCTAssertEqual(DeviceError.videoPermissionError.description, "videoPermissionError")
        XCTAssertEqual(DeviceError.audioInputDeviceNotRespondingError.description, "audioInputDeviceNotRespondingError")
        XCTAssertEqual(DeviceError.audioOutputDeviceNotRespondingError.description, "audioOutputDeviceNotRespondingError")
        XCTAssertEqual(DeviceError.noCameraSelected.description, "noCameraSelected")
        XCTAssertEqual(DeviceError.noAvailableAudioInputs.description, "noAvailableAudioInputs")
    }
}
