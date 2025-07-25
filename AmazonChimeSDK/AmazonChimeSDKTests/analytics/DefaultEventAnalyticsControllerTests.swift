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
    var eventReporterMock: EventReporterMock!
    
    private var mockMeetingStats: [AnyHashable: Any] = [:]
    private let mockMeetingStartDurationMs = 123

    override func setUp() {
        super.setUp()
        
        mockMeetingStats[EventAttributeName.meetingStartDurationMs] = mockMeetingStartDurationMs
        
        eventReporterMock = mock(EventReporter.self)
        meetingStatsCollectorMock = mock(MeetingStatsCollector.self)
        given(meetingStatsCollectorMock.getMeetingStats()).willReturn(mockMeetingStats)
        eventAnalyticsController = DefaultEventAnalyticsController(meetingSessionConfig: meetingSessionConfigurationMock,
                                                                   meetingStatsCollector: meetingStatsCollectorMock,
                                                                   logger: loggerMock,
                                                                   eventReporter: eventReporterMock)
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

    func testPublishEvent_eventReporter_report() {
        let mockObserver = mock(EventAnalyticsObserver.self)
        eventAnalyticsController.addEventAnalyticsObserver(observer: mockObserver)
        eventAnalyticsController.publishEvent(name: .meetingStartRequested)

        verify(eventReporterMock.report(event: any())).wasCalled(1)
    }
    
    func testPublishEvent_ShouldAddMeetingStats_WhenMeetingReconnected() {
        let eventCaptor = ArgumentCaptor<SDKEvent>()
        eventAnalyticsController.publishEvent(name: .meetingReconnected)
        verify(eventReporterMock.report(event: eventCaptor.any())).wasCalled()
        
        XCTAssertEqual(eventCaptor.value?.eventAttributes[EventAttributeName.meetingStartDurationMs] as! Int,
                       mockMeetingStartDurationMs)
    }

    func testPushHistoryState_eventReporter_report() {
        let mockObserver = mock(EventAnalyticsObserver.self)
        eventAnalyticsController.addEventAnalyticsObserver(observer: mockObserver)
        eventAnalyticsController.pushHistory(historyEventName: .meetingReconnected)

        verify(eventReporterMock.report(event: any())).wasCalled(1)
    }
}
