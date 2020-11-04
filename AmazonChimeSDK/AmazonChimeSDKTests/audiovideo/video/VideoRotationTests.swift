//
//  VideoRotationTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import AmazonChimeSDKMedia
import XCTest

class VideoRotationTests: XCTestCase {
    func testRawValueShouldMatch() {
        XCTAssertEqual(VideoRotation.rotation0.rawValue, 0)
        XCTAssertEqual(VideoRotation.rotation90.rawValue, 90)
        XCTAssertEqual(VideoRotation.rotation180.rawValue, 180)
        XCTAssertEqual(VideoRotation.rotation270.rawValue, 270)
    }

    func testToInternalShouldMatchVideoRotationInternal() {
        XCTAssertEqual(VideoRotation.rotation0.toInternal, VideoRotationInternal.rotation0)
        XCTAssertEqual(VideoRotation.rotation90.toInternal, VideoRotationInternal.rotation90)
        XCTAssertEqual(VideoRotation.rotation180.toInternal, VideoRotationInternal.rotation180)
        XCTAssertEqual(VideoRotation.rotation270.toInternal, VideoRotationInternal.rotation270)
    }

    func testDescriptionShouldMatch() {
        XCTAssertEqual(VideoRotation.rotation0.description, "rotation_0")
        XCTAssertEqual(VideoRotation.rotation90.description, "rotation_90")
        XCTAssertEqual(VideoRotation.rotation180.description, "rotation_180")
        XCTAssertEqual(VideoRotation.rotation270.description, "rotation_270")
    }
}
