//
//  MediaDeviceTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import AVFoundation
import XCTest

class MediaDeviceTests: XCTestCase {
    func testMediaDeviceShouldBeInitialized() {
        let mediaDevice = MediaDevice(label: "mediaDevice")

        XCTAssertEqual(mediaDevice.label, "mediaDevice")
        XCTAssertNil(mediaDevice.port)
        XCTAssertEqual(mediaDevice.type, .other)
    }

    func testDescriptionShouldMatch() {
        let mediaDevice = MediaDevice(label: "mediaDevice")

        XCTAssertEqual(mediaDevice.description, "mediaDevice - other")
    }
}
