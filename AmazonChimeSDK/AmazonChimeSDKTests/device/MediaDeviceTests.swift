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
    private var mediaDevice: MediaDevice?

    override func setUp() {
        super.setUp()
        mediaDevice = MediaDevice(label: "mediaDevice")
    }

    func testMediaDeviceShouldBeInitialized() {
        XCTAssertEqual(mediaDevice?.label, "mediaDevice")
        XCTAssertNil(mediaDevice?.port)
        XCTAssertEqual(mediaDevice?.type, .other)
        XCTAssertEqual(mediaDevice?.description, "mediaDevice - other")
    }
}
