//
//  DictionaryTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class DictionaryTests: XCTestCase {
    private var emptyDict: [String: Int] = [:]
    private var dict1 = ["a": 1]
    private var dict2 = ["a": 2]
    private var dict3 = ["a": 1, "b": 2]
    private var dict4 = ["b": 2]

    func testSubtractingShouldReturnUpdatedValueWhenUpdatingValue() {
        XCTAssertEqual(dict1, dict1.subtracting(dict: dict2))
    }

    func testSubtractingShouldReturnNewEntryWhenPassingInNewEntry() {
        XCTAssertEqual(dict4, dict3.subtracting(dict: dict1))
    }

    func testSubtractingShouldReturnEmptyWhenSubtractingItself() {
        XCTAssertEqual(emptyDict, dict1.subtracting(dict: dict1))
    }

    func testSubtractingShouldIgnoreNonexistedKey() {
        XCTAssertEqual(dict2, dict2.subtracting(dict: dict3))
        XCTAssertEqual(emptyDict, dict1.subtracting(dict: dict3))
    }
}
