//
//  DefaultEventAnalyticsControllerTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
@testable import AmazonChimeSDK
import Mockingbird
import XCTest

class DefaultEventAnalyticsControllerTests: CommonTestCase {
    var eventAnalyticsController: DefaultEventAnalyticsController!
    var meetingStatsCollectorMock: MeetingStatsCollectorMock!

    override func setUp() {
        super.setUp()
        meetingStatsCollectorMock = mock(MeetingStatsCollector.self)
        given(meetingStatsCollectorMock.getMeetingStats()).willReturn([AnyHashable: Any]())
        eventAnalyticsController = DefaultEventAnalyticsController(meetingSessionConfig: meetingSessionConfigurationMock,
                                                                   meetingStatsCollector: meetingStatsCollectorMock,
                                                                   logger: loggerMock)
    }

    func testPublishEvent_eventDidReceive() {
        let mockObserver = mock(EventAnalyticsObserver.self)
        eventAnalyticsController.addEventAnalyticsObserver(observer: mockObserver)
        eventAnalyticsController.publishEvent(name: .meetingStartRequested)
        let expectation = eventually {
            verify(mockObserver.eventDidReceive(name: .meetingStartRequested, attributes: any())).wasCalled()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
