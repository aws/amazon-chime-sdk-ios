//
//  MeetingSessionURLsTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class MeetingSessionURLsTests: XCTestCase {
    func testMeetingSessionURLsShouldBeInitialized() {
        let url = MeetingSessionURLs(audioFallbackUrl: "audioFallbackUrl",
                                     audioHostUrl: "audioHostUrl",
                                     turnControlUrl: "turnControlUrl",
                                     signalingUrl: "signalingUrl")

        XCTAssertEqual(url.audioFallbackUrl, "audioFallbackUrl")
        XCTAssertEqual(url.audioHostUrl, "audioHostUrl")
    }
}
