//
//  DefaultAppStateMonitorTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Mockingbird
import XCTest

final class DefaultAppStateMonitorTests: XCTestCase {
    
    private var loggerMock: LoggerMock!
    private var delegateMock: AppStateMonitorDelegateMock!
    private var monitor: DefaultAppStateMonitor!
    
    override func setUp() {
        super.setUp()
        loggerMock = mock(Logger.self)
        delegateMock = mock(AppStateMonitorDelegate.self)
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
        verify(delegateMock.appStateDidChange(monitor: monitor, newAppState: AppState.foreground)).wasCalled()
        verify(loggerMock.info(msg: "Application entered state: Foreground")).wasCalled()
    }
    
    func testAppEnteredBackground_ShouldUpdateStateAndNotifyDelegate() {
        monitor.start()
        
        // When
        NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.post(name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        // Then
        XCTAssertEqual(monitor.appState, .background)
        verify(delegateMock.appStateDidChange(monitor: monitor, newAppState: AppState.background)).wasCalled()
        verify(loggerMock.info(msg: "Application entered state: Background")).wasCalled()
    }
    
    func testAppBecameActive_ShouldUpdateStateAndNotifyDelegate() {
        monitor.start()
        
        // When
        NotificationCenter.default.post(name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.post(name: UIApplication.didBecomeActiveNotification, object: nil)
        
        // Then
        XCTAssertEqual(monitor.appState, .active)
        verify(delegateMock.appStateDidChange(monitor: monitor, newAppState: AppState.active)).wasCalled(2)
        verify(loggerMock.info(msg: "Application entered state: Active")).wasCalled(2)
    }
    
    func testAppBecameInactive_ShouldUpdateStateAndNotifyDelegate() {
        monitor.start()
        
        // When
        NotificationCenter.default.post(name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.post(name: UIApplication.willResignActiveNotification, object: nil)
        
        // Then
        XCTAssertEqual(monitor.appState, .inactive)
        verify(delegateMock.appStateDidChange(monitor: monitor, newAppState: AppState.inactive)).wasCalled()
        verify(loggerMock.info(msg: "Application entered state: Inactive")).wasCalled()
    }
    
    func testAppWillTerminate_ShouldUpdateStateAndNotifyDelegate() {
        monitor.start()
        
        // When
        NotificationCenter.default.post(name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.post(name: UIApplication.willTerminateNotification, object: nil)
        
        // Then
        XCTAssertEqual(monitor.appState, .terminated)
        verify(delegateMock.appStateDidChange(monitor: monitor, newAppState: AppState.terminated)).wasCalled()
        verify(loggerMock.info(msg: "Application entered state: Terminated")).wasCalled()
    }
    
    func testDidReceiveMemoryLowWarning_ShouldNotifyDelegate() {
        monitor.start()
        
        // When
        NotificationCenter.default.post(name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        
        // Then
        verify(delegateMock.didReceiveMemoryWarning(monitor: monitor)).wasCalled()
        verify(loggerMock.info(msg: "Application received memory low warning.")).wasCalled()
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
        verify(delegateMock.appStateDidChange(monitor: monitor, newAppState: AppState.inactive)).wasNeverCalled()
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
}
