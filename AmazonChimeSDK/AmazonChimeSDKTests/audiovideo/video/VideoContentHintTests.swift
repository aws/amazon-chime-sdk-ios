//
//  VideoContentHintTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import AmazonChimeSDKMedia
import XCTest

class VideoContentHintTests: XCTestCase {
    func testToInternalShouldMatchVideoContentHintInternal() {
        XCTAssertEqual(VideoContentHint.none.toInternal, VideoContentHintInternal.none)
        XCTAssertEqual(VideoContentHint.motion.toInternal, VideoContentHintInternal.motion)
        XCTAssertEqual(VideoContentHint.detail.toInternal, VideoContentHintInternal.detailed)
        XCTAssertEqual(VideoContentHint.text.toInternal, VideoContentHintInternal.text)
    }

    func testDescriptionShouldMatch() {
        XCTAssertEqual(VideoContentHint.none.description, "none")
        XCTAssertEqual(VideoContentHint.motion.description, "motion")
        XCTAssertEqual(VideoContentHint.detail.description, "detail")
        XCTAssertEqual(VideoContentHint.text.description, "text")
    }
}
