//
//  EventNameTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
@testable import AmazonChimeSDK
import XCTest

class EventNameTests: XCTestCase {
    func testDescriptionShouldMatch() {
        XCTAssertEqual(EventName.videoInputFailed.description, "videoInputFailed")
        XCTAssertEqual(EventName.meetingStartRequested.description, "meetingStartRequested")
        XCTAssertEqual(EventName.meetingStartSucceeded.description, "meetingStartSucceeded")
        XCTAssertEqual(EventName.meetingStartFailed.description, "meetingStartFailed")
        XCTAssertEqual(EventName.meetingFailed.description, "meetingFailed")
        XCTAssertEqual(EventName.meetingEnded.description, "meetingEnded")
    }
}
