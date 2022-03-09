//
//  TranscriptLanguageWithScoreTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class TranscriptLanguageWithScoreTests: XCTestCase {
    let languageCode = "en-US"
    let score = 0.0
   
    func testTranscriptLanguageWithScoreShouldInitialize() {
        let transcriptLanguageWithScore = TranscriptLanguageWithScore(languageCode: languageCode, score: score)

        XCTAssertNotNil(transcriptLanguageWithScore)
        XCTAssertEqual(transcriptLanguageWithScore.languageCode, languageCode)
        XCTAssertEqual(transcriptLanguageWithScore.score, score)
    }
}

