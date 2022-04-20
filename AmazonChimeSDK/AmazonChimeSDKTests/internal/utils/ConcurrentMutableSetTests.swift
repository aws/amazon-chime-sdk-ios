//
//  ConcurrentMutableSetTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class ConcurrentMutableSetTests: XCTestCase {
    private var set: ConcurrentMutableSet!

    override func setUp() {
        super.setUp()
        set = ConcurrentMutableSet()
    }

    func testPutAndContainsShouldWork() {
        set.add(1)
        XCTAssertTrue(set.contains(1))
    }

    func testRemoveShouldWork() {
        set.add(1)
        XCTAssertTrue(set.contains(1))

        set.remove(1)
        XCTAssertFalse(set.contains(1))
    }

    func testForEachShouldWork() {
        set.add(1)
        set.add(10)
        set.add(100)

        var sum: Int = 0
        var count: Int = 0
        set.forEach { item in
            guard let value = item as? Int else { return }
            count += 1
            sum += value
        }

        XCTAssertEqual(sum, 111)
        XCTAssertEqual(count, 3)
    }

    func testThreadSafety() {
        set.add(1)
        set.add(10)
        var count = 0
        var sum = 0
        let backgroundThreadEndedExpectation = XCTestExpectation(
            description: "The background thread was ended")
        let mainThreadEndedExpectation = XCTestExpectation(
            description: "The main thread was ended")

        DispatchQueue.global(qos: .userInteractive).async {
            self.set.forEach { item in
                sleep(2)
                guard let value = item as? Int, self.set.contains(item) else { return }
                count += 1
                sum += value
            }
            backgroundThreadEndedExpectation.fulfill()
        }
        DispatchQueue.main.async {
            sleep(1)
            self.set.remove(10)
            mainThreadEndedExpectation.fulfill()
        }

        wait(for: [backgroundThreadEndedExpectation, mainThreadEndedExpectation], timeout: 5)
        XCTAssertEqual(count, 2)
        XCTAssertEqual(sum, 11)
        XCTAssertEqual(set.count, 1)
        XCTAssert(set.contains(1))
    }

    func testThreadSafetyShouldFailForNormalSet() {
        let normalSet = NSMutableSet()
        normalSet.add(1)
        normalSet.add(10)
        var count = 0
        var sum = 0
        let backgroundThreadEndedExpectation = XCTestExpectation(
            description: "The background thread was ended")
        let mainThreadEndedExpectation = XCTestExpectation(
            description: "The main thread was ended")

        DispatchQueue.global(qos: .background).async {
            normalSet.forEach { item in
                sleep(2)
                guard let value = item as? Int, normalSet.contains(item) else { return }
                count += 1
                sum += value
            }
            backgroundThreadEndedExpectation.fulfill()
        }
        DispatchQueue.main.async {
            sleep(1)
            normalSet.remove(10)
            mainThreadEndedExpectation.fulfill()
        }

        wait(for: [backgroundThreadEndedExpectation, mainThreadEndedExpectation], timeout: 7)
        XCTAssertEqual(count, 1)
        XCTAssertEqual(sum, 1)
        XCTAssertEqual(normalSet.count, 1)
        XCTAssert(normalSet.contains(1))
    }
}
