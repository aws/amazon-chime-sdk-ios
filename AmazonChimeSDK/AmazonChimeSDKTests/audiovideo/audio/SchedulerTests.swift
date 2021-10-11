//
//  SchedulerTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@testable import AmazonChimeSDK
import XCTest

class SchedulerTests: XCTestCase {
    private var timer: IntervalScheduler = IntervalScheduler(intervalMs: 1, callback: {})
    private var callback = {}

    private let intervalMs = 1
    private let testTimeoutSecs = 0.01
    private let expectedCount = 5
    private let expectedTestDurationNanos: UInt64 = 5_000_000

    private func injectExpectation(expectation: XCTestExpectation) {
        callback = {
            expectation.fulfill()
        }
        timer = IntervalScheduler(intervalMs: intervalMs, callback: callback)
        expectation.expectedFulfillmentCount = 5
        expectation.assertForOverFulfill = true
    }

    func testTimerShouldMakeCallback() {
        let expectation = XCTestExpectation(
            description: "Callback is called once every millisecond for 5 milliseconds")
        injectExpectation(expectation: expectation)

        timer.start()
        let start = DispatchTime.now()
        // Must finish all executions before timeout
        wait(for: [expectation], timeout: testTimeoutSecs)
        let stop = DispatchTime.now()
        // Must take no less than expected (mininal) tasks duration
        XCTAssertGreaterThanOrEqual(stop.uptimeNanoseconds - start.uptimeNanoseconds, expectedTestDurationNanos)
    }

    func testTimerShouldStopMakingCallback() {
        let expectation = XCTestExpectation(
            description: "Callback is called once every millisecond for 5 milliseconds")
        injectExpectation(expectation: expectation)

        timer.start()
        timer.stop()
        expectation.isInverted = true
        wait(for: [expectation], timeout: testTimeoutSecs)
    }

    func testStartShouldBeIdempotent() {
        let expectation = XCTestExpectation(
            description: "Callback is called once every millisecond for 5 milliseconds")
        injectExpectation(expectation: expectation)

        timer.start()
        timer.start()
        let start = DispatchTime.now()
        // Must finish all executions before timeout
        wait(for: [expectation], timeout: testTimeoutSecs)
        let stop = DispatchTime.now()
        // Must take no less than expected (mininal) tasks duration
        XCTAssertGreaterThanOrEqual(stop.uptimeNanoseconds - start.uptimeNanoseconds, expectedTestDurationNanos)
    }

    func testStopShouldBeIdempotent() {
        let expectation = XCTestExpectation(
            description: "Callback is called once every millisecond for 5 milliseconds")
        injectExpectation(expectation: expectation)

        timer.start()
        timer.stop()
        timer.stop()
        expectation.isInverted = true
        wait(for: [expectation], timeout: testTimeoutSecs)
    }

    override func tearDown() {
        timer.stop()
    }
}
