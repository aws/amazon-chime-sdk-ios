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
    private func rewriteURL(url: String) -> String {
        return url.replacingOccurrences(of: "Url", with: "hello")
    }
    func testMeetingSessionURLsShouldBeInitialized() {
        let url = MeetingSessionURLs(audioFallbackUrl: "audioFallbackUrl",
                                     audioHostUrl: "audioHostUrl",
                                     turnControlUrl: "turnControlUrl",
                                     signalingUrl: "signalingUrl",
                                     urlRewriter: URLRewriterUtils.defaultUrlRewriter)

        XCTAssertEqual(url.audioFallbackUrl, "audioFallbackUrl")
        XCTAssertEqual(url.audioHostUrl, "audioHostUrl")
    }

    func testMeetingSessionURLsShouldBeRewritten() {
        let url = MeetingSessionURLs(audioFallbackUrl: "audioFallbackUrl",
                                     audioHostUrl: "audioHostUrl",
                                     turnControlUrl: "turnControlUrl",
                                     signalingUrl: "signalingUrl",
                                     urlRewriter: rewriteURL)

        XCTAssertEqual(url.audioFallbackUrl, "audioFallbackhello")
        XCTAssertEqual(url.audioHostUrl, "audioHosthello")
        XCTAssertEqual(url.turnControlUrl, "turnControlhello")
        XCTAssertEqual(url.signalingUrl, "signalinghello")
    }
}
