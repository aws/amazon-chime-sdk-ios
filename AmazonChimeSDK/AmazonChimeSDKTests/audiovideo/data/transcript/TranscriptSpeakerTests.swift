//
//  TranscriptSpeakerTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class TranscriptSpeakerTests: XCTestCase {
    let attendeeId = "attendee-id"
    let externalUserId = "external-user-id"

    func testTranscriptSpeakerShouldInitialize() {
        let transcriptSpeaker = TranscriptSpeaker(attendeeId: attendeeId, externalUserId: externalUserId)

        XCTAssertNotNil(transcriptSpeaker)
        XCTAssertEqual(transcriptSpeaker.attendeeId, attendeeId)
        XCTAssertEqual(transcriptSpeaker.externalUserId, externalUserId)
    }
}
