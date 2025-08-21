//
//  DefaultAppLifecycleObserverTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Mockingbird
import XCTest

final class DefaultAppLifecycleObserverTests: XCTestCase {
    
    private var eventAnalyticsControllerMock: EventAnalyticsControllerMock!
    private var loggerMock: LoggerMock!
    
    private var observer: DefaultAppLifecycleObserver!
    
    override func setUp() {
        
        eventAnalyticsControllerMock = mock(EventAnalyticsController.self)
        loggerMock = mock(Logger.self)
        
        observer = DefaultAppLifecycleObserver(eventAnalyticsController: eventAnalyticsControllerMock,
                                               logger: loggerMock)
    }
    
    override func tearDown() {
        observer = nil
        super.tearDown()
    }
    
    func test_didEnterBackground_logsAndPublishesEvent() {
        observer.startObserve()
        
        NotificationCenter.default.post(name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        verify(loggerMock.info(msg: "Application entered background")).wasCalled()
        verify(eventAnalyticsControllerMock.pushHistory(historyEventName: .appEnteredBackground)).wasCalled()
    }
    
    func test_didEnterForeground_logsAndPublishesEvent() {
        observer.startObserve()
        
        NotificationCenter.default.post(name: UIApplication.didBecomeActiveNotification, object: nil)
        
        verify(loggerMock.info(msg: "Application entered foreground")).wasCalled()
        verify(eventAnalyticsControllerMock.pushHistory(historyEventName: .appEnteredForeground)).wasCalled()
    }
}
