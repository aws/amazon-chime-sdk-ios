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

        // The quality-of-service (QoS) - '.userInteractive' has higher priority than '.background', which is performed more quickly and with more resources than lower priority work.
        // In order to pass tests, we give them higher priority to perform quickly.
        //
        // This one keeps the sleep-based interleaving on purpose. `forEach` holds the
        // lock for the whole iteration, so the main thread's write below blocks until
        // the iteration finishes and therefore lands last. Sequencing it with
        // semaphores (as the plain-dictionary test below does) would deadlock: the
        // background thread would wait for a signal from a main thread that is itself
        // blocked on the lock the background thread holds.
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

        // Generous timeout: the work takes ~2s, but a loaded machine can schedule the
        // threads much later. A tight bound here made this suite fail spuriously.
        wait(for: [backgroundThreadEndedExpectation, mainThreadEndedExpectation], timeout: 30)
        XCTAssertEqual(self.dict["?"], 2)
    }

    func testThreadSafetyShouldFailForNormalDict() {
        var normalDict = ["?": 0]
        let iterationStarted = DispatchSemaphore(value: 0)
        let mainThreadDidWrite = DispatchSemaphore(value: 0)
        let backgroundThreadEndedExpectation = XCTestExpectation(
            description: "The background thread was ended")

        // The interleaving is enforced with semaphores rather than sleeps so the
        // outcome does not depend on wall-clock timing:
        //   1. the background thread starts iterating and signals
        //   2. the main thread writes 2
        //   3. the background thread writes 1, overwriting it
        // A plain dictionary does not order these writes against each other, so the
        // main thread's write is silently lost. `ConcurrentDictionary` prevents this
        // by making the write above wait for the iteration to finish (see
        // `testThreadSafety`).
        DispatchQueue.global(qos: .userInitiated).async {
            normalDict.forEach { _ in
                iterationStarted.signal()
                XCTAssertEqual(mainThreadDidWrite.wait(timeout: .now() + 30), .success)
                normalDict["?"] = 1
            }
            backgroundThreadEndedExpectation.fulfill()
        }

        XCTAssertEqual(iterationStarted.wait(timeout: .now() + 30), .success)
        normalDict["?"] = 2
        mainThreadDidWrite.signal()

        wait(for: [backgroundThreadEndedExpectation], timeout: 30)
        XCTAssertEqual(normalDict["?"], 1)
    }
}
