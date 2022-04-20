//
//  ConcurrentDictionaryTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class ConcurrentDictionaryTests: XCTestCase {
    private var dict: ConcurrentDictionary<String, Int>!

    override func setUp() {
        super.setUp()
        self.dict = ConcurrentDictionary()
    }

    func testPutNonNilAndGetShouldWork() {
        dict["1+1="] = 2
        XCTAssertEqual(dict.getShallowDictCopy().count, 1)
        XCTAssertEqual(dict["1+1="], 2)
    }

    func testPutNilAndGetShouldWork() {
        dict["?+?="] = nil
        XCTAssertEqual(dict.getShallowDictCopy().count, 0)
        XCTAssertNil(dict["?+?="])
    }

    func testForEachShouldWork() {
        dict["1+0="] = 1
        dict["10+0="] = 10
        dict["100+0="] = 100

        var sum: Int = 0
        var count: Int = 0
        dict.forEach { _, value in
            count += 1
            sum += value
        }

        XCTAssertEqual(sum, 111)
        XCTAssertEqual(count, 3)
    }

    func testSortedShouldWork() {
        dict["1+0="] = 1
        dict["1+1="] = 2

        let sortedAscending = dict.sorted(by: { $0.value > $1.value })
        XCTAssertEqual(sortedAscending[0].value, 2)
        XCTAssertEqual(sortedAscending[1].value, 1)

        let sortedDecending = dict.sorted(by: { $0.value < $1.value })
        XCTAssertEqual(sortedDecending[0].value, 1)
        XCTAssertEqual(sortedDecending[1].value, 2)
    }

    func testGetShallowDictCopyShouldReturnShallowCopy() {
        dict["1+1="] = 1
        var dictCopy = dict.getShallowDictCopy()
        dictCopy["1+1="] = 2

        XCTAssertEqual(dict["1+1="], 1)
        XCTAssertEqual(dictCopy["1+1="], 2)
    }

    func testThreadSafety() {
        dict["?"] = 0
        let backgroundThreadEndedExpectation = XCTestExpectation(
            description: "The background thread was ended")
        let mainThreadEndedExpectation = XCTestExpectation(
            description: "The main thread was ended")

        DispatchQueue.global(qos: .userInteractive).async {
            self.dict.forEach { _ in
                sleep(2)
                self.dict["?"] = 1
            }
            backgroundThreadEndedExpectation.fulfill()
        }
        DispatchQueue.main.async {
            sleep(1)
            self.dict["?"] = 2
            mainThreadEndedExpectation.fulfill()
        }

        wait(for: [backgroundThreadEndedExpectation, mainThreadEndedExpectation], timeout: 5)
        XCTAssertEqual(self.dict["?"], 2)
    }

    func testThreadSafetyShouldFailForNormalDict() {
        var normalDict = ["?": 0]
        let backgroundThreadEndedExpectation = XCTestExpectation(
            description: "The background thread was ended")
        let mainThreadEndedExpectation = XCTestExpectation(
            description: "The main thread was ended")

        DispatchQueue.global(qos: .background).async {
            normalDict.forEach { _ in
                sleep(2)
                normalDict["?"] = 1
            }
            backgroundThreadEndedExpectation.fulfill()
        }
        DispatchQueue.main.async {
            sleep(1)
            normalDict["?"] = 2
            mainThreadEndedExpectation.fulfill()
        }

        wait(for: [backgroundThreadEndedExpectation, mainThreadEndedExpectation], timeout: 5)
        XCTAssertEqual(normalDict["?"], 1)
    }
}
