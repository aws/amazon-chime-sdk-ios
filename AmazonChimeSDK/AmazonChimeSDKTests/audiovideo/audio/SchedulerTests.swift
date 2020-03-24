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
    private let fiveMilliSecondsInSeconds = 0.005
    private let fiveMilliSecondsInNanoSeconds: UInt64 = 5000000
    private let expectation = XCTestExpectation(
        description: "Callback is called once every millisecond for 5 milliseconds")

    override func setUp() {
        super.setUp()
        callback = {
            self.expectation.fulfill()
        }
        timer = IntervalScheduler(intervalMs: 1, callback: callback)
        expectation.expectedFulfillmentCount = 5
        expectation.assertForOverFulfill = true
    }

    func testTimerShouldMakeCallback() {
        timer.start()
        let start = DispatchTime.now()
        // Must take no longer than 5ms
        wait(for: [expectation], timeout: fiveMilliSecondsInSeconds)
        let stop = DispatchTime.now()
        // Must take no less than 5ms
        XCTAssertGreaterThanOrEqual(stop.uptimeNanoseconds - start.uptimeNanoseconds, fiveMilliSecondsInNanoSeconds)
    }

    func testTimerShouldStopMakingCallback() {
        timer.start()
        timer.stop()
        expectation.isInverted = true
        wait(for: [expectation], timeout: fiveMilliSecondsInSeconds)
    }

    func testStartShouldBeIdempotent() {
        timer.start()
        timer.start()
        let start = DispatchTime.now()
        // Must take no longer than 5ms
        wait(for: [expectation], timeout: fiveMilliSecondsInSeconds)
        let stop = DispatchTime.now()
        // Must take no less than 5ms
        XCTAssertGreaterThanOrEqual(stop.uptimeNanoseconds - start.uptimeNanoseconds, fiveMilliSecondsInNanoSeconds)
    }

    func testStopShouldBeIdempotent() {
        timer.start()
        timer.stop()
        timer.stop()
        expectation.isInverted = true
        wait(for: [expectation], timeout: fiveMilliSecondsInSeconds)
    }

    override func tearDown() {
        timer.stop()
    }
}
