//
//  DefaultMeetingStatsCollectorTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
@testable import AmazonChimeSDK
import Mockingbird
import XCTest

class DefaultMeetingStatsCollectorTests: CommonTestCase {
    var meetingStatsCollector: DefaultMeetingStatsCollector!

    override func setUp() {
        super.setUp()
        meetingStatsCollector = DefaultMeetingStatsCollector(logger: loggerMock)
    }

    func testIncrementRetryCount() {
        let retryCount = meetingStatsCollector.getMeetingStats()[EventAttributeName.retryCount] as? Int
        meetingStatsCollector.incrementRetryCount()
        let updatedRetryCount = meetingStatsCollector.getMeetingStats()[EventAttributeName.retryCount] as? Int
        if let expected = retryCount, let result = updatedRetryCount {
            XCTAssertEqual(expected + 1, result)
        } else {
            XCTFail("The type conversion failed")
        }
    }

    func testIncrementPoorConnectionCount() {
        let poorConnectionCount = meetingStatsCollector.getMeetingStats()[EventAttributeName.poorConnectionCount] as? Int
        meetingStatsCollector.incrementPoorConnectionCount()
        let updatedPoorConnectionCount = meetingStatsCollector.getMeetingStats()[EventAttributeName.poorConnectionCount] as? Int
        if let expected = poorConnectionCount, let result = updatedPoorConnectionCount {
            XCTAssertEqual(expected + 1, result)
        } else {
            XCTFail("The type conversion failed")
        }
    }
    
    func testGetMeetingStats_ShouldReturnCorrectMeetingReconnectDuration() {
        meetingStatsCollector.updateMeetingStartReconnectingTimeMs()
        sleep(3)
        meetingStatsCollector.updateMeetingReconnectedTimeMs()
        let reconnectDuration = meetingStatsCollector.getMeetingStats()[EventAttributeName.meetingReconnectDurationMs] as! Int64
        // The reconnect duration should be close to 3 seconds
        XCTAssert(reconnectDuration >= 2800 && reconnectDuration <= 3200)
    }
    
    func testGetMeetingStats_ShouldReturn0MeetingReconnectDuration_WhenReconnectedTimeIsNotSet() {
        meetingStatsCollector.updateMeetingStartReconnectingTimeMs()
        let reconnectDuration = meetingStatsCollector.getMeetingStats()[EventAttributeName.meetingReconnectDurationMs] as! Int64
        XCTAssert(reconnectDuration == 0)
    }
    
    func testGetMeetingStats_ShouldReturn0MeetingReconnectDuration_WhenReconnectedTimeIsSetBeforeStartReconnect() {
        meetingStatsCollector.updateMeetingReconnectedTimeMs()
        meetingStatsCollector.updateMeetingStartReconnectingTimeMs()
        let reconnectDuration = meetingStatsCollector.getMeetingStats()[EventAttributeName.meetingReconnectDurationMs] as! Int64
        XCTAssert(reconnectDuration == 0)
    }

    func testResetMeetingStats() {
        meetingStatsCollector.resetMeetingStats()
        let stats = meetingStatsCollector.getMeetingStats()
        XCTAssertEqual(stats[EventAttributeName.poorConnectionCount] as? Int, 0)
        XCTAssertEqual(stats[EventAttributeName.maxVideoTileCount] as? Int, 0)
        XCTAssertEqual(stats[EventAttributeName.retryCount] as? Int, 0)
        XCTAssertEqual(stats[EventAttributeName.meetingDurationMs] as? Int, 0)
        XCTAssertEqual(stats[EventAttributeName.meetingStartDurationMs] as? Int, 0)
        XCTAssertEqual(stats[EventAttributeName.meetingReconnectDurationMs] as? Int64, 0)
    }

}
