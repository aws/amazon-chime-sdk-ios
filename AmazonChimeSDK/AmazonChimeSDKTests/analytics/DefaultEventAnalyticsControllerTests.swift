//
//  DefaultEventAnalyticsControllerTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
@testable import AmazonChimeSDK
import Cuckoo
import XCTest

class DefaultEventAnalyticsControllerTests: CommonTestCase {
    var eventAnalyticsController: DefaultEventAnalyticsController!
    var meetingStatsCollectorMock: MockMeetingStatsCollector!
    var eventReporterMock: MockEventReporter!
    var appStateMonitorMock: MockAppStateMonitor!
    
    private var mockMeetingStats: [AnyHashable: Any] = [:]
    private let mockMeetingStartDurationMs = 123
    private let mockMeetingReconnectDurationMs = 123

    override func setUp() {
        super.setUp()
        
        mockMeetingStats[EventAttributeName.meetingStartDurationMs] = mockMeetingStartDurationMs
        mockMeetingStats[EventAttributeName.meetingReconnectDurationMs] = mockMeetingReconnectDurationMs
        
        eventReporterMock = MockEventReporter().withEnabledDefaultImplementation(EventReporterStub())
        appStateMonitorMock = MockAppStateMonitor().withEnabledDefaultImplementation(AppStateMonitorStub())
        meetingStatsCollectorMock = MockMeetingStatsCollector().withEnabledDefaultImplementation(MeetingStatsCollectorStub())
        stub(meetingStatsCollectorMock) { stub in
            when(stub.getMeetingStats()).thenReturn(mockMeetingStats)
        }
        stub(appStateMonitorMock) { stub in
            when(stub.appState.get).thenReturn(.active)
            when(stub.getBatteryLevel()).thenReturn(NSNumber(value: 0.77))
            when(stub.getBatteryState()).thenReturn(BatteryState.charging)
            when(stub.isLowPowerModeEnabled()).thenReturn(true)
            when(stub.getNetworkConnectionType()).thenReturn(NetworkConnectionType.cellular)
        }
        
        eventAnalyticsController = DefaultEventAnalyticsController(meetingSessionConfig: meetingSessionConfigurationMock,
                                                                   meetingStatsCollector: meetingStatsCollectorMock,
                                                                   appStateMonitor: appStateMonitorMock,
                                                                   logger: loggerMock,
                                                                   eventReporter: eventReporterMock)
    }

    func testPublishEvent_eventDidReceive() {
        let mockObserver = MockEventAnalyticsObserver().withEnabledDefaultImplementation(EventAnalyticsObserverStub())
        eventAnalyticsController.addEventAnalyticsObserver(observer: mockObserver)
        eventAnalyticsController.publishEvent(name: .meetingStartRequested)
        let expectation = XCTestExpectation(description: "eventually")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            verify(mockObserver).eventDidReceive(name: equal(to: .meetingStartRequested), attributes: any())
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func testPublishEvent_eventReporter_report() {
        let mockObserver = MockEventAnalyticsObserver().withEnabledDefaultImplementation(EventAnalyticsObserverStub())
        eventAnalyticsController.addEventAnalyticsObserver(observer: mockObserver)
        eventAnalyticsController.publishEvent(name: .meetingStartRequested)

        verify(eventReporterMock, times(1)).report(event: any())
    }
    
    func testPublishEvent_ShouldAddMeetingStats_WhenMeetingReconnected() {
        let eventCaptor = ArgumentCaptor<SDKEvent>()
        eventAnalyticsController.publishEvent(name: .meetingReconnected)
        verify(eventReporterMock).report(event: eventCaptor.capture())
        
        XCTAssertEqual(eventCaptor.value?.eventAttributes[EventAttributeName.meetingStartDurationMs] as? Int,
                       mockMeetingStartDurationMs)
        XCTAssertEqual(eventCaptor.value?.eventAttributes[EventAttributeName.meetingReconnectDurationMs] as? Int,
                       mockMeetingReconnectDurationMs)
    }
    
    func testPublishEvent_ShouldAddMeetingStats_WhenSignalingDropped() {
        let eventCaptor = ArgumentCaptor<SDKEvent>()
        eventAnalyticsController.publishEvent(name: .videoClientSignalingDropped)
        verify(eventReporterMock).report(event: eventCaptor.capture())
        
        XCTAssertEqual(eventCaptor.value?.eventAttributes[EventAttributeName.meetingStartDurationMs] as? Int,
                       mockMeetingStartDurationMs)
    }
    
    func testPublishEvent_ShouldNotContainReconnectDurationAttribute_WhenEventIsNotMeetingReconnected() {
        let eventCaptor = ArgumentCaptor<SDKEvent>()
        eventAnalyticsController.publishEvent(name: .meetingStartFailed)
        verify(eventReporterMock).report(event: eventCaptor.capture())
        
        XCTAssertNil(eventCaptor.value?.eventAttributes[EventAttributeName.meetingReconnectDurationMs])
    }
    
    func testPublishEvent_WillPublishAppAttributes() {
        let eventCaptor = ArgumentCaptor<SDKEvent>()
        
        stub(appStateMonitorMock) { stub in
            when(stub.appState.get).thenReturn(.background)
            when(stub.getBatteryLevel()).thenReturn(NSNumber.init(value: 0.17))
            when(stub.getBatteryState()).thenReturn(BatteryState.full)
            when(stub.isLowPowerModeEnabled()).thenReturn(true)
        }
        
        eventAnalyticsController.publishEvent(name: .meetingStartFailed)
        verify(eventReporterMock).report(event: eventCaptor.capture())
        
        let attributes = eventCaptor.value?.eventAttributes
        
        XCTAssertEqual(attributes?[EventAttributeName.appState] as? AppState,
                       AppState.background)
        XCTAssertEqual((attributes?[EventAttributeName.batteryLevel] as? NSNumber)?.floatValue,
                       0.17)
        XCTAssertEqual(attributes?[EventAttributeName.batteryState] as? BatteryState,
                       BatteryState.full)
    }

    func testPushHistoryState_eventReporter_report() {
        let mockObserver = MockEventAnalyticsObserver().withEnabledDefaultImplementation(EventAnalyticsObserverStub())
        eventAnalyticsController.addEventAnalyticsObserver(observer: mockObserver)
        eventAnalyticsController.pushHistory(historyEventName: .meetingReconnected)

        verify(eventReporterMock, times(1)).report(event: any())
    }
    
    func testPushHistoryState_WillPublishAppAttributes() {
        let eventCaptor = ArgumentCaptor<SDKEvent>()
        
        stub(appStateMonitorMock) { stub in
            when(stub.appState.get).thenReturn(.background)
            when(stub.getBatteryLevel()).thenReturn(NSNumber.init(value: 0.17))
            when(stub.getBatteryState()).thenReturn(BatteryState.full)
        }
        
        eventAnalyticsController.pushHistory(historyEventName: .meetingEnded)
        verify(eventReporterMock).report(event: eventCaptor.capture())
        
        let attributes = eventCaptor.value?.eventAttributes
        
        XCTAssertEqual(attributes?[EventAttributeName.appState] as? AppState,
                       AppState.background)
        XCTAssertEqual((attributes?[EventAttributeName.batteryLevel] as? NSNumber)?.floatValue,
                       0.17)
        XCTAssertEqual(attributes?[EventAttributeName.batteryState] as? BatteryState,
                       BatteryState.full)
    }
    
    func testAppStateDidChange_ShouldPublishEvent() {
        let eventCaptor = ArgumentCaptor<SDKEvent>()
        let mockObserver = MockEventAnalyticsObserver().withEnabledDefaultImplementation(EventAnalyticsObserverStub())
        
        stub(appStateMonitorMock) { stub in
            when(stub.appState.get).thenReturn(.background)
        }
        
        eventAnalyticsController.addEventAnalyticsObserver(observer: mockObserver)
        eventAnalyticsController.appStateDidChange(monitor: self.appStateMonitorMock, newAppState: .background)

        verify(eventReporterMock, times(1)).report(event: eventCaptor.capture())
        
        XCTAssertEqual(eventCaptor.value?.eventAttributes[EventAttributeName.appState] as? AppState, AppState.background)
        sleep(1)
        verify(mockObserver, never()).eventDidReceive(name: any(), attributes: any())
    }
    
    func testDidReceiveMemoryWarning_ShouldPublishEvent() {
        let eventCaptor = ArgumentCaptor<SDKEvent>()
        let mockObserver = MockEventAnalyticsObserver().withEnabledDefaultImplementation(EventAnalyticsObserverStub())
        
        stub(appStateMonitorMock) { stub in
            when(stub.appState.get).thenReturn(.background)
        }
        
        eventAnalyticsController.addEventAnalyticsObserver(observer: mockObserver)
        eventAnalyticsController.didReceiveMemoryWarning(monitor: self.appStateMonitorMock)

        verify(eventReporterMock, times(1)).report(event: eventCaptor.capture())
        
        XCTAssertEqual(eventCaptor.value?.name, EventName.appMemoryLow.description)
        sleep(1)
        verify(mockObserver, never()).eventDidReceive(name: any(), attributes: any())
    }
    
    func testNetworkConnectionTypeDidChange_ShouldPublishEvent() {
        let eventCaptor = ArgumentCaptor<SDKEvent>()
        let mockObserver = MockEventAnalyticsObserver().withEnabledDefaultImplementation(EventAnalyticsObserverStub())
        
        stub(appStateMonitorMock) { stub in
            when(stub.getNetworkConnectionType()).thenReturn(NetworkConnectionType.cellular)
        }
        
        eventAnalyticsController.addEventAnalyticsObserver(observer: mockObserver)
        eventAnalyticsController.networkConnectionTypeDidChange(monitor: self.appStateMonitorMock,
                                                                newNetworkConnectionType: NetworkConnectionType.cellular)

        verify(eventReporterMock, times(1)).report(event: eventCaptor.capture())
        
        XCTAssertEqual(eventCaptor.value?.name, EventName.networkConnectionTypeChanged.description)
        sleep(1)
        verify(mockObserver, never()).eventDidReceive(name: any(), attributes: any())
    }
}
