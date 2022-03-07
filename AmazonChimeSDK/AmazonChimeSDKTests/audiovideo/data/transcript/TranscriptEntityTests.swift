//
//  TranscriptEntityTest.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class TranscriptEntityTests: XCTestCase {
    let type = "PII"
    let category = "ALL"
    let content = "test"
    let confidence = 0.0
    let startTimeMs: Int64 = 1632087029249
    let endTimeMs: Int64 = 1632087029250

    func testTranscriptEntityShouldInitialize() {
        let transcriptEntity = TranscriptEntity(type: type,
                                                content: content,
                                            category: category,
                                            confidence: confidence,
                                            startTimeMs: startTimeMs,
                                            endTimeMs: endTimeMs)

        XCTAssertNotNil(transcriptEntity)
        XCTAssertEqual(transcriptEntity.type, type)
        XCTAssertEqual(transcriptEntity.content, content)
        XCTAssertEqual(transcriptEntity.category, category)
        XCTAssertEqual(transcriptEntity.confidence, confidence)
        XCTAssertEqual(transcriptEntity.startTimeMs, startTimeMs)
        XCTAssertEqual(transcriptEntity.endTimeMs, endTimeMs)
    }
}
