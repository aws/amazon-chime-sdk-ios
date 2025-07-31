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
        XCTAssertEqual(EventName.audioInputFailed.description, "audioInputFailed")
        XCTAssertEqual(EventName.videoInputFailed.description, "videoInputFailed")
        XCTAssertEqual(EventName.deviceAccessFailed.description, "deviceAccessFailed")
        XCTAssertEqual(EventName.meetingStartRequested.description, "meetingStartRequested")
        XCTAssertEqual(EventName.meetingStartSucceeded.description, "meetingStartSucceeded")
        XCTAssertEqual(EventName.meetingReconnected.description, "meetingReconnected")
        XCTAssertEqual(EventName.meetingStartFailed.description, "meetingStartFailed")
        XCTAssertEqual(EventName.meetingFailed.description, "meetingFailed")
        XCTAssertEqual(EventName.meetingEnded.description, "meetingEnded")
        XCTAssertEqual(EventName.unknown.description, "unknown")
    }
    
    func testEventNameShouldBeAbleToConvertFromString() {
        XCTAssertEqual(EventName.toEventName(name: "audioInputFailed"),
                       EventName.audioInputFailed)
        XCTAssertEqual(EventName.toEventName(name: "videoInputFailed"),
                       EventName.videoInputFailed)
        XCTAssertEqual(EventName.toEventName(name: "deviceAccessFailed"),
                       EventName.deviceAccessFailed)
        XCTAssertEqual(EventName.toEventName(name: "meetingStartRequested"),
                       EventName.meetingStartRequested)
        XCTAssertEqual(EventName.toEventName(name: "meetingStartSucceeded"),
                       EventName.meetingStartSucceeded)
        XCTAssertEqual(EventName.toEventName(name: "meetingReconnected"),
                       EventName.meetingReconnected)
        XCTAssertEqual(EventName.toEventName(name: "meetingStartFailed"),
                       EventName.meetingStartFailed)
        XCTAssertEqual(EventName.toEventName(name: "meetingFailed"),
                       EventName.meetingFailed)
        XCTAssertEqual(EventName.toEventName(name: "meetingEnded"),
                       EventName.meetingEnded)
        XCTAssertEqual(EventName.toEventName(name: "invalidEventName"),
                       EventName.unknown)
    }
}
