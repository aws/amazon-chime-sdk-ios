//
//  TranscriptItemTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class TranscriptItemTests: XCTestCase {
    let startTimeMs: Int64 = 1632087029249
    let endTimeMs: Int64 = 1632087029250
    let attendee = AttendeeInfo(attendeeId: "attendee-id", externalUserId: "external-user-id")
    let content = "test"
    let stable = false
    let confidence = 0.0

    func testTranscriptItemShouldInitialize() {
        let transcriptItem = TranscriptItem(type: .punctuation,
                                            startTimeMs: startTimeMs,
                                            endTimeMs: endTimeMs,
                                            attendee: attendee,
                                            content: content,
                                            vocabularyFilterMatch: true,
                                            stable: stable,
                                            confidence: confidence)

        XCTAssertNotNil(transcriptItem)
        XCTAssertEqual(transcriptItem.type, .punctuation)
        XCTAssertEqual(transcriptItem.startTimeMs, startTimeMs)
        XCTAssertEqual(transcriptItem.endTimeMs, endTimeMs)
        XCTAssertEqual(transcriptItem.attendee, attendee)
        XCTAssertEqual(transcriptItem.content, content)
        XCTAssertEqual(transcriptItem.vocabularyFilterMatch, true)
        XCTAssertEqual(transcriptItem.stable, stable)
        XCTAssertEqual(transcriptItem.confidence, confidence)
    }
}
