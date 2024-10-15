//
//  TranscriptResultTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class TranscriptResultTests: XCTestCase {
    let resultId = "result-id"
    let channelId = "channel-id"
    let startTimeMs: Int64 = 1632087029249
    let endTimeMs: Int64 = 1632087029250
    let languageCode = "en-US"

    func testTranscriptResultShouldInitialize() {
        let transcriptResult = TranscriptResult(resultId: "result-id",
                                                channelId: "channel-id",
                                                isPartial: true,
                                                startTimeMs: startTimeMs,
                                                endTimeMs: endTimeMs,
                                                alternatives: [],
                                                languageCode: languageCode,
                                                languageIdentification: [])
        
        XCTAssertNotNil(transcriptResult)
        XCTAssertEqual(transcriptResult.resultId, resultId)
        XCTAssertEqual(transcriptResult.channelId, channelId)
        XCTAssertEqual(transcriptResult.isPartial, true)
        XCTAssertEqual(transcriptResult.startTimeMs, startTimeMs)
        XCTAssertEqual(transcriptResult.endTimeMs, endTimeMs)
        XCTAssertEqual(transcriptResult.alternatives, [])
        XCTAssertEqual(transcriptResult.languageCode, languageCode)
        XCTAssertEqual(transcriptResult.languageIdentification, [])
    }
}
