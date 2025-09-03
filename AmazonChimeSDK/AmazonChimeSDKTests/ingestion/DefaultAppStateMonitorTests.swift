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
}
