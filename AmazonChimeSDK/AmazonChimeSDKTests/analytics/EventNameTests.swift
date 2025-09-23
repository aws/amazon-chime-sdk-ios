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
        XCTAssertEqual(EventName.meetingStartRequested.description, "meetingStartRequested")
        XCTAssertEqual(EventName.meetingStartSucceeded.description, "meetingStartSucceeded")
        XCTAssertEqual(EventName.meetingReconnected.description, "meetingReconnected")
        XCTAssertEqual(EventName.meetingStartFailed.description, "meetingStartFailed")
        XCTAssertEqual(EventName.meetingFailed.description, "meetingFailed")
        XCTAssertEqual(EventName.meetingEnded.description, "meetingEnded")
        XCTAssertEqual(EventName.videoClientSignalingDropped.description, "videoClientSignalingDropped")
        XCTAssertEqual(EventName.contentShareSignalingDropped.description, "contentShareSignalingDropped")
        XCTAssertEqual(EventName.contentShareStartRequested.description, "contentShareStartRequested")
        XCTAssertEqual(EventName.contentShareStarted.description, "contentShareStarted")
        XCTAssertEqual(EventName.contentShareStopped.description, "contentShareStopped")
        XCTAssertEqual(EventName.contentShareFailed.description, "contentShareFailed")
        XCTAssertEqual(EventName.appStateChanged.description, "appStateChanged")
        XCTAssertEqual(EventName.appMemoryLow.description, "appMemoryLow")
        XCTAssertEqual(EventName.voiceFocusEnabled.description, "voiceFocusEnabled")
        XCTAssertEqual(EventName.voiceFocusDisabled.description, "voiceFocusDisabled")
        XCTAssertEqual(EventName.voiceFocusEnableFailed.description, "voiceFocusEnableFailed")
        XCTAssertEqual(EventName.voiceFocusDisableFailed.description, "voiceFocusDisableFailed")
        XCTAssertEqual(EventName.audioInputSelected.description, "audioInputSelected")
        XCTAssertEqual(EventName.videoInputSelected.description, "videoInputSelected")
        XCTAssertEqual(EventName.unknown.description, "unknown")
    }
    
    func testEventNameShouldBeAbleToConvertFromString() {
        XCTAssertEqual(EventName.toEventName(name: "audioInputFailed"),
                       EventName.audioInputFailed)
        XCTAssertEqual(EventName.toEventName(name: "videoInputFailed"),
                       EventName.videoInputFailed)
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
        XCTAssertEqual(EventName.toEventName(name: "videoClientSignalingDropped"),
                       EventName.videoClientSignalingDropped)
        XCTAssertEqual(EventName.toEventName(name: "contentShareSignalingDropped"),
                       EventName.contentShareSignalingDropped)
        XCTAssertEqual(EventName.toEventName(name: "contentShareStartRequested"),
                       EventName.contentShareStartRequested)
        XCTAssertEqual(EventName.toEventName(name: "contentShareStarted"),
                       EventName.contentShareStarted)
        XCTAssertEqual(EventName.toEventName(name: "contentShareStopped"),
                       EventName.contentShareStopped)
        XCTAssertEqual(EventName.toEventName(name: "contentShareFailed"),
                       EventName.contentShareFailed)
        XCTAssertEqual(EventName.toEventName(name: "appStateChanged"),
                       EventName.appStateChanged)
        XCTAssertEqual(EventName.toEventName(name: "appMemoryLow"),
                       EventName.appMemoryLow)
        XCTAssertEqual(EventName.toEventName(name: "voiceFocusEnabled"),
                       EventName.voiceFocusEnabled)
        XCTAssertEqual(EventName.toEventName(name: "voiceFocusDisabled"),
                       EventName.voiceFocusDisabled)
        XCTAssertEqual(EventName.toEventName(name: "voiceFocusEnableFailed"),
                       EventName.voiceFocusEnableFailed)
        XCTAssertEqual(EventName.toEventName(name: "voiceFocusDisableFailed"),
                       EventName.voiceFocusDisableFailed)
        XCTAssertEqual(EventName.toEventName(name: "audioInputSelected"),
                       EventName.audioInputSelected)
        XCTAssertEqual(EventName.toEventName(name: "videoInputSelected"),
                       EventName.videoInputSelected)
        XCTAssertEqual(EventName.toEventName(name: "audioInterruptionBegan"),
                       EventName.audioInterruptionBegan)
        XCTAssertEqual(EventName.toEventName(name: "audioInterruptionEnded"),
                       EventName.audioInterruptionEnded)
        XCTAssertEqual(EventName.toEventName(name: "videoInterruptionBegan"),
                       EventName.videoInterruptionBegan)
        XCTAssertEqual(EventName.toEventName(name: "videoInterruptionEnded"),
                       EventName.videoInterruptionEnded)
        XCTAssertEqual(EventName.toEventName(name: "invalidEventName"),
                       EventName.unknown)
    }
}
