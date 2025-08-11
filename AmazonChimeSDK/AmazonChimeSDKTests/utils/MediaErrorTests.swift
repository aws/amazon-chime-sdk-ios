//
//  MediaErrorTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class MediaErrorTests: XCTestCase {
    func testDescriptionShouldMatch() {
        XCTAssertEqual(MediaError.illegalState.description, "illegalState")
        XCTAssertEqual(MediaError.audioFailedToStart.description, "audioFailedToStart")
        XCTAssertEqual(MediaError.noCameraSelected.description, "noCameraSelected")
        XCTAssertEqual(MediaError.noAudioDevices.description, "noAudioDevices")
        XCTAssertEqual(MediaError.overrideOutputAudioPortFailed.description, "overrideOutputAudioPortFailed")
        XCTAssertEqual(MediaError.setPreferredAudioInputFailed.description, "setPreferredAudioInputFailed")
    }
}
