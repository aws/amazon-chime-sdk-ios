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
    let transcriptSpeaker = TranscriptSpeaker(attendeeId: "attendee-id", externalUserId: "external-user-id")
    let content = "test"

    func testTranscriptItemShouldInitialize() {
        let transcriptItem = TranscriptItem(type: .punctuation,
                                            startTimeMs: startTimeMs,
                                            endTimeMs: endTimeMs,
                                            attendee: transcriptSpeaker,
                                            content: content,
                                            vocabularyFilterMatch: true)

        XCTAssertNotNil(transcriptItem)
        XCTAssertEqual(transcriptItem.type, .punctuation)
        XCTAssertEqual(transcriptItem.startTimeMs, startTimeMs)
        XCTAssertEqual(transcriptItem.endTimeMs, endTimeMs)
        XCTAssertEqual(transcriptItem.attendee, transcriptSpeaker)
        XCTAssertEqual(transcriptItem.content, content)
        XCTAssertEqual(transcriptItem.vocabularyFilterMatch, true)
    }
}
