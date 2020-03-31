//
//  MeetingSessionStatusTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class MeetingSessionStatusTests: XCTestCase {
    func testMeetingSessionStatusShouldBeInitialized() {
        XCTAssertEqual(MeetingSessionStatus(statusCode: MeetingSessionStatusCode.ok).statusCode,
                       MeetingSessionStatusCode.ok)
    }
}
