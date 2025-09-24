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
        XCTAssertEqual(MeetingHistoryEventName.videoClientSignalingDropped.description, "videoClientSignalingDropped")
        XCTAssertEqual(MeetingHistoryEventName.contentShareSignalingDropped.description, "contentShareSignalingDropped")
        XCTAssertEqual(MeetingHistoryEventName.contentShareStartRequested.description, "contentShareStartRequested")
        XCTAssertEqual(MeetingHistoryEventName.contentShareStarted.description, "contentShareStarted")
        XCTAssertEqual(MeetingHistoryEventName.contentShareStopped.description, "contentShareStopped")
        XCTAssertEqual(MeetingHistoryEventName.contentShareFailed.description, "contentShareFailed")
        XCTAssertEqual(MeetingHistoryEventName.appStateChanged.description, "appStateChanged")
        XCTAssertEqual(MeetingHistoryEventName.appMemoryLow.description, "appMemoryLow")
    }
}
