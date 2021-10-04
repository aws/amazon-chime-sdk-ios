//
//  TranscriptTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class TranscriptTests: XCTestCase {
    func testTranscriptShouldBeInitialized() {
        let transcript = Transcript(results: [])
        
        XCTAssertNotNil(transcript)
        XCTAssertEqual(transcript.results, [])
    }
}
