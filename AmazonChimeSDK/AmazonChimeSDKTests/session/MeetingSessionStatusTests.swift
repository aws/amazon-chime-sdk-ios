//
//  MeetingSessionStatusTest.swift
//  AmazonChimeSDKTests
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

@testable import AmazonChimeSDK
import XCTest

class MeetingSessionStatusTests: XCTestCase {
    func testMeetingSessionStatusShouldBeInitialized() {
        XCTAssertEqual(MeetingSessionStatusCode.ok,
                       MeetingSessionStatus(statusCode: MeetingSessionStatusCode.ok).statusCode)
    }
}
