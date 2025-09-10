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
    var appStateMonitorMock: AppStateMonitorMock!
    
    private var mockMeetingStats: [AnyHashable: Any] = [:]
    private let mockMeetingStartDurationMs = 123
    private let mockMeetingReconnectDurationMs = 123

    override func setUp() {
        super.setUp()
        
        mockMeetingStats[EventAttributeName.meetingStartDurationMs] = mockMeetingStartDurationMs
        mockMeetingStats[EventAttributeName.meetingReconnectDurationMs] = mockMeetingReconnectDurationMs
        
        eventReporterMock = mock(EventReporter.self)
        appStateMonitorMock = mock(AppStateMonitor.self)
        meetingStatsCollectorMock = mock(MeetingStatsCollector.self)
        given(meetingStatsCollectorMock.getMeetingStats()).willReturn(mockMeetingStats)
        given(appStateMonitorMock.getAppState()).willReturn(.active)
        given(appStateMonitorMock.getBatteryLevel()).willReturn(NSNumber(value: 0.77))
        given(appStateMonitorMock.getBatteryState()).willReturn(BatteryState.charging)
        
        eventAnalyticsController = DefaultEventAnalyticsController(meetingSessionConfig: meetingSessionConfigurationMock,
                                                                   meetingStatsCollector: meetingStatsCollectorMock,
                                                                   appStateMonitor: appStateMonitorMock,
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
        XCTAssertEqual(eventCaptor.value?.eventAttributes[EventAttributeName.meetingReconnectDurationMs] as! Int,
                       mockMeetingReconnectDurationMs)
    }
    
    func testPublishEvent_ShouldAddMeetingStats_WhenSignalingDropped() {
        let eventCaptor = ArgumentCaptor<SDKEvent>()
        eventAnalyticsController.publishEvent(name: .videoClientSignalingDropped)
        verify(eventReporterMock.report(event: eventCaptor.any())).wasCalled()
        
        XCTAssertEqual(eventCaptor.value?.eventAttributes[EventAttributeName.meetingStartDurationMs] as! Int,
                       mockMeetingStartDurationMs)
    }
    
    func testPublishEvent_ShouldNotContainReconnectDurationAttribute_WhenEventIsNotMeetingReconnected() {
        let eventCaptor = ArgumentCaptor<SDKEvent>()
        eventAnalyticsController.publishEvent(name: .meetingStartFailed)
        verify(eventReporterMock.report(event: eventCaptor.any())).wasCalled()
        
        XCTAssertNil(eventCaptor.value?.eventAttributes[EventAttributeName.meetingReconnectDurationMs])
    }
    
    func testPublishEvent_WillPublishAppAttributes() {
        let eventCaptor = ArgumentCaptor<SDKEvent>()
        
        given(appStateMonitorMock.getAppState()).willReturn(.background)
        given(appStateMonitorMock.getBatteryLevel()).willReturn(NSNumber.init(value: 0.17))
        given(appStateMonitorMock.getBatteryState()).willReturn(BatteryState.full)
        
        eventAnalyticsController.publishEvent(name: .meetingStartFailed)
        verify(eventReporterMock.report(event: eventCaptor.any())).wasCalled()
        
        let attributes = eventCaptor.value?.eventAttributes
        
        XCTAssertEqual(attributes?[EventAttributeName.appState] as! AppState,
                       AppState.background)
        XCTAssertEqual((attributes?[EventAttributeName.batteryLevel] as! NSNumber).floatValue,
                       0.17)
        XCTAssertEqual(attributes?[EventAttributeName.batteryState] as! BatteryState,
                       BatteryState.full)
    }

    func testPushHistoryState_eventReporter_report() {
        let mockObserver = mock(EventAnalyticsObserver.self)
        eventAnalyticsController.addEventAnalyticsObserver(observer: mockObserver)
        eventAnalyticsController.pushHistory(historyEventName: .meetingReconnected)

        verify(eventReporterMock.report(event: any())).wasCalled(1)
    }
    
    func testPushHistoryState_WillPublishAppAttributes() {
        let eventCaptor = ArgumentCaptor<SDKEvent>()
        
        given(appStateMonitorMock.getAppState()).willReturn(.background)
        given(appStateMonitorMock.getBatteryLevel()).willReturn(NSNumber.init(value: 0.17))
        given(appStateMonitorMock.getBatteryState()).willReturn(BatteryState.full)
        
        eventAnalyticsController.pushHistory(historyEventName: .meetingEnded)
        verify(eventReporterMock.report(event: eventCaptor.any())).wasCalled()
        
        let attributes = eventCaptor.value?.eventAttributes
        
        XCTAssertEqual(attributes?[EventAttributeName.appState] as! AppState,
                       AppState.background)
        XCTAssertEqual((attributes?[EventAttributeName.batteryLevel] as! NSNumber).floatValue,
                       0.17)
        XCTAssertEqual(attributes?[EventAttributeName.batteryState] as! BatteryState,
                       BatteryState.full)
    }
    
    func testAppStateDidChange_ShouldPublishEvent() {
        let eventCaptor = ArgumentCaptor<SDKEvent>()
        let mockObserver = mock(EventAnalyticsObserver.self)
        
        given(appStateMonitorMock.getAppState()).willReturn(.background)
        
        eventAnalyticsController.addEventAnalyticsObserver(observer: mockObserver)
        eventAnalyticsController.appStateDidChange(monitor: self.appStateMonitorMock, newAppState: .background)

        verify(eventReporterMock.report(event: eventCaptor.any())).wasCalled(1)
        
        XCTAssertEqual(eventCaptor.value?.eventAttributes[EventAttributeName.appState] as? AppState, AppState.background)
        sleep(1)
        verify(mockObserver.eventDidReceive(name: any(), attributes: any())).wasNeverCalled()
    }
    
    func testDidReceiveMemoryWarning_ShouldPublishEvent() {
        let eventCaptor = ArgumentCaptor<SDKEvent>()
        let mockObserver = mock(EventAnalyticsObserver.self)
        
        given(appStateMonitorMock.getAppState()).willReturn(.background)
        
        eventAnalyticsController.addEventAnalyticsObserver(observer: mockObserver)
        eventAnalyticsController.didReceiveMemoryWarning(monitor: self.appStateMonitorMock)

        verify(eventReporterMock.report(event: eventCaptor.any())).wasCalled(1)
        
        XCTAssertEqual(eventCaptor.value?.name, EventName.appMemoryLow.description)
        sleep(1)
        verify(mockObserver.eventDidReceive(name: any(), attributes: any())).wasNeverCalled()
    }
}
