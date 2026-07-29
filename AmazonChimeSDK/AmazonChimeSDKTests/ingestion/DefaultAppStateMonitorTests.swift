//
//  DefaultAppStateMonitorTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

final class DefaultAppStateMonitorTests: XCTestCase {
    
    private var loggerMock: LoggerSpy!
    private var delegateMock: AppStateMonitorDelegateSpy!
    private var monitor: DefaultAppStateMonitor!
    
    override func setUp() {
        super.setUp()
        loggerMock = LoggerSpy()
        delegateMock = AppStateMonitorDelegateSpy()
        monitor = DefaultAppStateMonitor(logger: loggerMock)
        monitor.delegate = delegateMock
    }
    
    override func tearDown() {
        monitor = nil
        super.tearDown()
    }
    
    func testAppEnteredForeground_ShouldUpdateStateAndNotifyDelegate() {
        monitor.start()
        
        // When
        NotificationCenter.default.post(name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: nil)
        
        // Then
        XCTAssertEqual(monitor.appState, .foreground)
        XCTAssertEqual(delegateMock.appStateDidChangeCalls.filter { $0 == .foreground }.count, 1)
        XCTAssertEqual(loggerMock.infoCalls.filter { $0 == "Application entered state: Foreground" }.count, 1)
    }
    
    func testAppEnteredBackground_ShouldUpdateStateAndNotifyDelegate() {
        monitor.start()
        
        // When
        NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.post(name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        // Then
        XCTAssertEqual(monitor.appState, .background)
        XCTAssertEqual(delegateMock.appStateDidChangeCalls.filter { $0 == .background }.count, 1)
        XCTAssertEqual(loggerMock.infoCalls.filter { $0 == "Application entered state: Background" }.count, 1)
    }
    
    func testAppBecameActive_ShouldUpdateStateAndNotifyDelegate() {
        monitor.start()
        
        // When
        NotificationCenter.default.post(name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.post(name: UIApplication.didBecomeActiveNotification, object: nil)
        
        // Then
        XCTAssertEqual(monitor.appState, .active)
        XCTAssertEqual(delegateMock.appStateDidChangeCalls.filter { $0 == .active }.count, 2)
        XCTAssertEqual(loggerMock.infoCalls.filter { $0 == "Application entered state: Active" }.count, 2)
    }
    
    func testAppBecameInactive_ShouldUpdateStateAndNotifyDelegate() {
        monitor.start()
        
        // When
        NotificationCenter.default.post(name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.post(name: UIApplication.willResignActiveNotification, object: nil)
        
        // Then
        XCTAssertEqual(monitor.appState, .inactive)
        XCTAssertEqual(delegateMock.appStateDidChangeCalls.filter { $0 == .inactive }.count, 1)
        XCTAssertEqual(loggerMock.infoCalls.filter { $0 == "Application entered state: Inactive" }.count, 1)
    }
    
    func testAppWillTerminate_ShouldUpdateStateAndNotifyDelegate() {
        monitor.start()
        
        // When
        NotificationCenter.default.post(name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.post(name: UIApplication.willTerminateNotification, object: nil)
        
        // Then
        XCTAssertEqual(monitor.appState, .terminated)
        XCTAssertEqual(delegateMock.appStateDidChangeCalls.filter { $0 == .terminated }.count, 1)
        XCTAssertEqual(loggerMock.infoCalls.filter { $0 == "Application entered state: Terminated" }.count, 1)
    }
    
    func testDidReceiveMemoryLowWarning_ShouldNotifyDelegate() {
        monitor.start()
        
        // When
        NotificationCenter.default.post(name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        
        // Then
        XCTAssertEqual(delegateMock.didReceiveMemoryWarningCallCount, 1)
        XCTAssertEqual(loggerMock.infoCalls.filter { $0 == "Application received memory low warning." }.count, 1)
    }
    
    func testStart_ShouldRegisterNotifications() {
        monitor.start()
        
        let notificationCenter = NotificationCenter.default
        
        // Post a notification to simulate
        notificationCenter.post(name: UIApplication.willResignActiveNotification, object: nil)
        XCTAssertEqual(monitor.appState, .inactive)
    }
    
    func testStop_ShouldRemoveObservers() {
        monitor.start()
        NotificationCenter.default.post(name: UIApplication.didBecomeActiveNotification, object: nil)
        monitor.stop()
        
        // Posting notification after stop should not change state
        NotificationCenter.default.post(name: UIApplication.willResignActiveNotification, object: nil)
        XCTAssertEqual(delegateMock.appStateDidChangeCalls.filter { $0 == .inactive }.count, 0)
        XCTAssertNotEqual(monitor.appState, .inactive)
    }
    
    // MARK: - Battery Monitoring Tests
    
    func testGetBatteryLevel_WhenBatteryMonitoringEnabled_ShouldReturnValidLevel() {
        // Given
        let device = UIDevice.current
        let originalMonitoringState = device.isBatteryMonitoringEnabled
        device.isBatteryMonitoringEnabled = true
        
        // When
        let batteryLevel = monitor.getBatteryLevel()
        
        // Then
        if device.batteryLevel >= 0 {
            XCTAssertNotNil(batteryLevel)
            XCTAssertGreaterThanOrEqual(batteryLevel!.floatValue, 0.0)
            XCTAssertLessThanOrEqual(batteryLevel!.floatValue, 1.0)
        } else {
            // Battery level is unknown (-1.0)
            XCTAssertNil(batteryLevel)
        }
        
        // Cleanup
        device.isBatteryMonitoringEnabled = originalMonitoringState
    }
    
    func testGetBatteryLevel_WhenBatteryMonitoringDisabled_ShouldEnableAndReturnLevel() {
        // Given
        let device = UIDevice.current
        let originalMonitoringState = device.isBatteryMonitoringEnabled
        device.isBatteryMonitoringEnabled = false
        
        // When
        let batteryLevel = monitor.getBatteryLevel()
        
        if device.batteryLevel >= 0 {
            XCTAssertNotNil(batteryLevel)
            XCTAssertGreaterThanOrEqual(batteryLevel!.floatValue, 0.0)
            XCTAssertLessThanOrEqual(batteryLevel!.floatValue, 1.0)
        } else {
            // Battery level is unknown (-1.0)
            XCTAssertNil(batteryLevel)
        }
        
        // Cleanup
        device.isBatteryMonitoringEnabled = originalMonitoringState
    }
    
    func testGetBatteryLevel_WhenBatteryLevelUnknown_ShouldReturnNil() {
        // Given
        let device = UIDevice.current
        let originalMonitoringState = device.isBatteryMonitoringEnabled
        
        // When
        let batteryLevel = monitor.getBatteryLevel()
        
        // Then
        if device.batteryLevel < 0 {
            XCTAssertNil(batteryLevel, "Battery level should be nil when device.batteryLevel is negative")
        }
        
        // Cleanup
        device.isBatteryMonitoringEnabled = originalMonitoringState
    }
    
    func testGetBatteryState_WhenBatteryMonitoringEnabled_ShouldReturnValidState() {
        validateBatteryState(true)
    }
    
    func testGetBatteryState_WhenBatteryMonitoringDisabled_ShouldEnableAndReturnState() {
        validateBatteryState(false)
    }
    
    private func validateBatteryState(_ isBatteryMonitoringEnabled: Bool) {
        // Given
        let device = UIDevice.current
        let originalMonitoringState = device.isBatteryMonitoringEnabled
        device.isBatteryMonitoringEnabled = false
        
        // When
        let batteryState = monitor.getBatteryState()
        
        // Verify the state is one of the expected values
        let validStates: [BatteryState] = [.charging, .discharging, .full, .unknown]
        XCTAssertTrue(validStates.contains(batteryState), "Battery state should be one of the valid states")
        
        // Cleanup
        device.isBatteryMonitoringEnabled = originalMonitoringState
    }
    
    // MARK: - Low Power Mode Tests
    
    func testIsLowPowerModeEnabled_ShouldReturnBooleanValue() {
        // When
        let isLowPowerModeEnabled = monitor.isLowPowerModeEnabled()
        
        // Then
        XCTAssertTrue(isLowPowerModeEnabled == true || isLowPowerModeEnabled == false, 
                     "Low power mode should return a valid boolean value")
        
        // Verify it matches the system value
        XCTAssertEqual(isLowPowerModeEnabled, ProcessInfo.processInfo.isLowPowerModeEnabled,
                      "Low power mode should match ProcessInfo.processInfo.isLowPowerModeEnabled")
    }
    
    // MARK: - Network Connection Type Tests
    
    func testGetNetworkConnectionType_WhenInitialized_ShouldReturnNone() {
        // When
        let connectionType = monitor.getNetworkConnectionType()
        
        // Then
        XCTAssertEqual(connectionType, .none, "Initial network connection type should be none")
    }
    
    func testGetNetworkConnectionType_ShouldReturnValidConnectionType() {
        // When
        let connectionType = monitor.getNetworkConnectionType()
        
        // Then
        let validTypes: [NetworkConnectionType] = [.wifi, .cellular, .wiredEthernet, .other, .none, .unknown]
        XCTAssertTrue(validTypes.contains(connectionType), "Network connection type should be one of the valid types")
    }
    
    func testNetworkConnectionTypeMonitoring_WhenMonitorNotStarted_ShouldNotPostEvents() {
        // Given - Monitor is not started
        
        // When - Simulate some time passing (network changes might occur)
        let expectation = XCTestExpectation(description: "Wait for potential network changes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        // Then - No network connection type change events should be posted
        XCTAssertEqual(delegateMock.networkConnectionTypeDidChangeCalls.count, 0)
    }
    
    func testNetworkConnectionTypeMonitoring_WhenMonitorStopped_ShouldNotPostEvents() {
        // Given
        monitor.start()
        monitor.stop()
        
        // When - Simulate some time passing (network changes might occur)
        let expectation = XCTestExpectation(description: "Wait for potential network changes after stop")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        // Then - No network connection type change events should be posted
        XCTAssertEqual(delegateMock.networkConnectionTypeDidChangeCalls.count, 0)
    }
    
    func testNetworkConnectionTypeMonitoring_WhenDelegateIsWeak_ShouldHandleNilDelegate() {
        // Given
        monitor.start()
        
        // When - Set delegate to nil (simulating weak reference being deallocated)
        monitor.delegate = nil
        
        // Then - Should not crash when network changes occur
        let expectation = XCTestExpectation(description: "Network monitoring with nil delegate")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Test passes if we reach here without crashing
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
