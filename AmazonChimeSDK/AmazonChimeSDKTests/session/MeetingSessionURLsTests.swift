//
//  MeetingSessionURLsTest.swift
//  AmazonChimeSDKTests
//
//  Created by Wang, Haoran on 2/4/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

@testable import AmazonChimeSDK
import XCTest

class MeetingSessionURLsTests: XCTestCase {

    func testMeetingSessionURLsShouldBeInitialized() {
        let url = MeetingSessionURLs(audioHostURL: "audioHostURL")
        XCTAssertEqual("audioHostURL", url.audioHostURL)
    }

}
