//
//  MediaDeviceTypeTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class MediaDeviceTypeTests: XCTestCase {
    func testDescriptionShouldMatch() {
        XCTAssertEqual(MediaDeviceType.audioBluetooth.description, "audioBluetooth")
        XCTAssertEqual(MediaDeviceType.audioWiredHeadset.description, "audioWiredHeadset")
        XCTAssertEqual(MediaDeviceType.audioBuiltInSpeaker.description, "audioBuiltInSpeaker")
        XCTAssertEqual(MediaDeviceType.audioHandset.description, "audioHandset")
        XCTAssertEqual(MediaDeviceType.videoFrontCamera.description, "videoFrontCamera")
        XCTAssertEqual(MediaDeviceType.videoBackCamera.description, "videoBackCamera")
        XCTAssertEqual(MediaDeviceType.other.description, "other")
    }
}
