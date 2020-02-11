//
//  MeetingSessionStatusTest.swift
//  AmazonChimeSDKTests
//
//  Created by Wang, Haoran on 2/5/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

@testable import AmazonChimeSDK
import XCTest

class MeetingSessionStatusTests: XCTestCase {

    func testMeetingSessionStatusShouldBeInitialized() {
        XCTAssertEqual(MeetingSessionStatusCode.ok,
                       MeetingSessionStatus(statusCode: MeetingSessionStatusCode.ok).statusCode)
    }

}
