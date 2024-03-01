//
//  StringExtensionTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class StringExtensionTests: XCTestCase {
    
    func testIsBlankShouldReturnTrueIfStringIsEmpty() {
        let str = ""
        XCTAssertTrue(str.isBlank)
    }
    
    func testIsBlankShouldReturnTrueIfStringContainsOnlyBlankSpaces() {
        let str = "   "
        XCTAssertTrue(str.isBlank)
    }
    
    func testIsBlankShouldReturnTrueIfStringContainsOnlyBlankSpacesAndNewLine() {
        let str = "\n   "
        XCTAssertTrue(str.isBlank)
    }
    
    func testIsBlankShouldReturnFalseIfStringContainsCharacters() {
        let str = "abc"
        XCTAssertFalse(str.isBlank)
    }
}
