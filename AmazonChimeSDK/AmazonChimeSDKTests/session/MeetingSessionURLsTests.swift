//
//  MeetingSessionURLsTest.swift
//  AmazonChimeSDKTests
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

@testable import AmazonChimeSDK
import XCTest

class MeetingSessionURLsTests: XCTestCase {
    func testMeetingSessionURLsShouldBeInitialized() {
        let url = MeetingSessionURLs(audioFallbackUrl: "audioFallbackUrl",
                                     audioHostUrl: "audioHostUrl",
                                     turnControlUrl: "turnControlUrl",
                                     signalingUrl: "signalingUrl")
        XCTAssertEqual("audioFallbackUrl", url.audioFallbackUrl)
        XCTAssertEqual("audioHostUrl", url.audioHostUrl)
    }
}
