//
//  TranscriptAlternativeTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class TranscriptAlternativeTests: XCTestCase {
    let transcript = "test"

    func testTranscriptAlternativeShouldInitialize() {
        let transcriptAlternative = TranscriptAlternative(items: [], transcript: transcript)
        
        XCTAssertNotNil(transcriptAlternative)
        XCTAssertEqual(transcriptAlternative.items, [])
        XCTAssertEqual(transcriptAlternative.transcript, transcript)
    }
}
