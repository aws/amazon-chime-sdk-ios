//
//  DefaultAppLifecycleObserver.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import UIKit

@objcMembers public class DefaultAppLifecycleObserver: AppLifecycleObserver {
    
    private let eventAnalyticsController: EventAnalyticsController
    private let logger: Logger
    
    init(eventAnalyticsController: EventAnalyticsController,
         logger: Logger) {
        self.eventAnalyticsController = eventAnalyticsController
        self.logger = logger
    }
    
    public func startObserve() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didEnterForeground),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    public func stopObserve() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func didEnterForeground() {
        logger.info(msg: "Application entered foreground")
        eventAnalyticsController.pushHistory(historyEventName: .appEnteredForeground)
    }

    @objc private func didEnterBackground() {
        logger.info(msg: "Application entered background")
        eventAnalyticsController.pushHistory(historyEventName: .appEnteredBackground)
    }

    deinit {
        stopObserve()
    }
}
