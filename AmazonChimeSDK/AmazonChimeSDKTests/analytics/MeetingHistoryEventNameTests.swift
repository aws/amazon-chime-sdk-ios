//
//  MeetingHistoryEventNameTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
@testable import AmazonChimeSDK
import XCTest

class MeetingHistoryEventNameTests: XCTestCase {
    func testDescriptionShouldMatch() {
        XCTAssertEqual(MeetingHistoryEventName.audioInputSelected.description, "audioInputSelected")
        XCTAssertEqual(MeetingHistoryEventName.videoInputSelected.description, "videoInputSelected")
        XCTAssertEqual(MeetingHistoryEventName.audioInputFailed.description, "audioInputFailed")
        XCTAssertEqual(MeetingHistoryEventName.videoInputFailed.description, "videoInputFailed")
        XCTAssertEqual(MeetingHistoryEventName.meetingStartRequested.description, "meetingStartRequested")
        XCTAssertEqual(MeetingHistoryEventName.meetingStartSucceeded.description, "meetingStartSucceeded")
        XCTAssertEqual(MeetingHistoryEventName.meetingEnded.description, "meetingEnded")
        XCTAssertEqual(MeetingHistoryEventName.meetingFailed.description, "meetingFailed")
        XCTAssertEqual(MeetingHistoryEventName.meetingReconnected.description, "meetingReconnected")
        XCTAssertEqual(MeetingHistoryEventName.signalingDropped.description, "signalingDropped")
    }
}
