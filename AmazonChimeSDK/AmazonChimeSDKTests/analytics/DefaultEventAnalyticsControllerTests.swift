//
//  DefaultEventAnalyticsControllerTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
@testable import AmazonChimeSDK
import XCTest

class DefaultEventAnalyticsControllerTests: CommonTestCase {
    var eventAnalyticsController: DefaultEventAnalyticsController!
    var meetingStatsCollectorMock: MeetingStatsCollectorSpy!
    var eventReporterMock: EventReporterSpy!
    var appStateMonitorMock: AppStateMonitorSpy!
    
    private var mockMeetingStats: [AnyHashable: Any] = [:]
    private let mockMeetingStartDurationMs = 123
    private let mockMeetingReconnectDurationMs = 123

    override func setUp() {
        super.setUp()
        
        mockMeetingStats[EventAttributeName.meetingStartDurationMs] = mockMeetingStartDurationMs
        mockMeetingStats[EventAttributeName.meetingReconnectDurationMs] = mockMeetingReconnectDurationMs
        
        eventReporterMock = EventReporterSpy()
        appStateMonitorMock = AppStateMonitorSpy()
        meetingStatsCollectorMock = MeetingStatsCollectorSpy()
        meetingStatsCollectorMock.getMeetingStatsReturn = mockMeetingStats
        appStateMonitorMock.appStateReturn = .active
        appStateMonitorMock.getBatteryLevelReturn = NSNumber(value: 0.77)
        appStateMonitorMock.getBatteryStateReturn = BatteryState.charging
        appStateMonitorMock.isLowPowerModeEnabledReturn = true
        appStateMonitorMock.getNetworkConnectionTypeReturn = NetworkConnectionType.cellular
        
        eventAnalyticsController = DefaultEventAnalyticsController(meetingSessionConfig: meetingSessionConfigurationMock,
                                                                   meetingStatsCollector: meetingStatsCollectorMock,
                                                                   appStateMonitor: appStateMonitorMock,
                                                                   logger: loggerMock,
                                                                   eventReporter: eventReporterMock)
    }

    func testPublishEvent_eventDidReceive() {
        let mockObserver = EventAnalyticsObserverSpy()
        eventAnalyticsController.addEventAnalyticsObserver(observer: mockObserver)
        eventAnalyticsController.publishEvent(name: .meetingStartRequested)
        let expectation = XCTestExpectation(description: "eventually")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            verify(mockObserver.eventDidReceiveCalls) { $0.name == .meetingStartRequested }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func testPublishEvent_eventReporter_report() {
        let mockObserver = EventAnalyticsObserverSpy()
        eventAnalyticsController.addEventAnalyticsObserver(observer: mockObserver)
        eventAnalyticsController.publishEvent(name: .meetingStartRequested)

        verify(eventReporterMock.reportCalls)
    }
    
    func testPublishEvent_ShouldAddMeetingStats_WhenMeetingReconnected() {
                eventAnalyticsController.publishEvent(name: .meetingReconnected)
        verify(eventReporterMock.reportCalls)
        
        XCTAssertEqual(eventReporterMock.reportCalls.last?.eventAttributes[EventAttributeName.meetingStartDurationMs] as? Int,
                       mockMeetingStartDurationMs)
        XCTAssertEqual(eventReporterMock.reportCalls.last?.eventAttributes[EventAttributeName.meetingReconnectDurationMs] as? Int,
                       mockMeetingReconnectDurationMs)
    }
    
    func testPublishEvent_ShouldAddMeetingStats_WhenSignalingDropped() {
                eventAnalyticsController.publishEvent(name: .videoClientSignalingDropped)
        verify(eventReporterMock.reportCalls)
        
        XCTAssertEqual(eventReporterMock.reportCalls.last?.eventAttributes[EventAttributeName.meetingStartDurationMs] as? Int,
                       mockMeetingStartDurationMs)
    }
    
    func testPublishEvent_ShouldNotContainReconnectDurationAttribute_WhenEventIsNotMeetingReconnected() {
                eventAnalyticsController.publishEvent(name: .meetingStartFailed)
        verify(eventReporterMock.reportCalls)
        
        XCTAssertNil(eventReporterMock.reportCalls.last?.eventAttributes[EventAttributeName.meetingReconnectDurationMs])
    }
    
    func testPublishEvent_WillPublishAppAttributes() {
                appStateMonitorMock.appStateReturn = .background
        appStateMonitorMock.getBatteryLevelReturn = NSNumber(value: 0.17)
        appStateMonitorMock.getBatteryStateReturn = BatteryState.full
        appStateMonitorMock.isLowPowerModeEnabledReturn = true
        
        eventAnalyticsController.publishEvent(name: .meetingStartFailed)
        verify(eventReporterMock.reportCalls)
        
        let attributes = eventReporterMock.reportCalls.last?.eventAttributes
        
        XCTAssertEqual(attributes?[EventAttributeName.appState] as? AppState,
                       AppState.background)
        XCTAssertEqual((attributes?[EventAttributeName.batteryLevel] as? NSNumber)?.floatValue,
                       0.17)
        XCTAssertEqual(attributes?[EventAttributeName.batteryState] as? BatteryState,
                       BatteryState.full)
    }

    func testPushHistoryState_eventReporter_report() {
        let mockObserver = EventAnalyticsObserverSpy()
        eventAnalyticsController.addEventAnalyticsObserver(observer: mockObserver)
        eventAnalyticsController.pushHistory(historyEventName: .meetingReconnected)

        verify(eventReporterMock.reportCalls)
    }
    
    func testPushHistoryState_WillPublishAppAttributes() {
                appStateMonitorMock.appStateReturn = .background
        appStateMonitorMock.getBatteryLevelReturn = NSNumber(value: 0.17)
        appStateMonitorMock.getBatteryStateReturn = BatteryState.full
        
        eventAnalyticsController.pushHistory(historyEventName: .meetingEnded)
        verify(eventReporterMock.reportCalls)
        
        let attributes = eventReporterMock.reportCalls.last?.eventAttributes
        
        XCTAssertEqual(attributes?[EventAttributeName.appState] as? AppState,
                       AppState.background)
        XCTAssertEqual((attributes?[EventAttributeName.batteryLevel] as? NSNumber)?.floatValue,
                       0.17)
        XCTAssertEqual(attributes?[EventAttributeName.batteryState] as? BatteryState,
                       BatteryState.full)
    }
    
    func testAppStateDidChange_ShouldPublishEvent() {
                let mockObserver = EventAnalyticsObserverSpy()
        
        appStateMonitorMock.appStateReturn = .background
        
        eventAnalyticsController.addEventAnalyticsObserver(observer: mockObserver)
        eventAnalyticsController.appStateDidChange(monitor: self.appStateMonitorMock, newAppState: .background)

        verify(eventReporterMock.reportCalls)
        
        XCTAssertEqual(eventReporterMock.reportCalls.last?.eventAttributes[EventAttributeName.appState] as? AppState, AppState.background)
        sleep(1)
        verify(mockObserver.eventDidReceiveCalls, never())
    }
    
    func testDidReceiveMemoryWarning_ShouldPublishEvent() {
                let mockObserver = EventAnalyticsObserverSpy()
        
        appStateMonitorMock.appStateReturn = .background
        
        eventAnalyticsController.addEventAnalyticsObserver(observer: mockObserver)
        eventAnalyticsController.didReceiveMemoryWarning(monitor: self.appStateMonitorMock)

        verify(eventReporterMock.reportCalls)
        
        XCTAssertEqual(eventReporterMock.reportCalls.last?.name, EventName.appMemoryLow.description)
        sleep(1)
        verify(mockObserver.eventDidReceiveCalls, never())
    }
    
    func testNetworkConnectionTypeDidChange_ShouldPublishEvent() {
                let mockObserver = EventAnalyticsObserverSpy()
        
        appStateMonitorMock.getNetworkConnectionTypeReturn = NetworkConnectionType.cellular
        
        eventAnalyticsController.addEventAnalyticsObserver(observer: mockObserver)
        eventAnalyticsController.networkConnectionTypeDidChange(monitor: self.appStateMonitorMock,
                                                                newNetworkConnectionType: NetworkConnectionType.cellular)

        verify(eventReporterMock.reportCalls)
        
        XCTAssertEqual(eventReporterMock.reportCalls.last?.name, EventName.networkConnectionTypeChanged.description)
        sleep(1)
        verify(mockObserver.eventDidReceiveCalls, never())
    }
}
