//
//  TranscriptionStatusTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class TranscriptionStatusTests: XCTestCase {
    let eventTimeMs: Int64 = 1632087029249
    let transcriptionRegion = "us-east-1"
    let transcriptionConfiguration = "transcription-configuration"
    let message = "Internal server error"

    func testTranscriptionStatusShouldInitialize() {
        let transcriptionStatus = TranscriptionStatus(type: .failed,
                                                      eventTimeMs: eventTimeMs,
                                                      transcriptionRegion: transcriptionRegion,
                                                      transcriptionConfiguration: transcriptionConfiguration,
                                                      message: message)

        XCTAssertNotNil(transcriptionStatus)
        XCTAssertEqual(transcriptionStatus.type, .failed)
        XCTAssertEqual(transcriptionStatus.eventTimeMs, eventTimeMs)
        XCTAssertEqual(transcriptionStatus.transcriptionRegion, transcriptionRegion)
        XCTAssertEqual(transcriptionStatus.transcriptionConfiguration, transcriptionConfiguration)
        XCTAssertEqual(transcriptionStatus.message, message)
    }
}
