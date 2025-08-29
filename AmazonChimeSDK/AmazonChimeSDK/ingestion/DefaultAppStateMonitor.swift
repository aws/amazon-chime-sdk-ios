//
//  DefaultAppStateMonitor.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import UIKit

@objcMembers public class DefaultAppStateMonitor: AppStateMonitor {
    
    public weak var delegate: AppStateMonitorDelegate?
    private let logger: Logger
    
    // App states should be posted only when the meeting session is running
    private var shouldPostEvent: Bool = false
    
    public private(set) var appState: AppState {
        didSet {
            logger.info(msg: "Application entered state: \(appState.description)")
            guard shouldPostEvent else { return }
            self.delegate?.appStateDidChange(monitor: self, newAppState: appState)
        }
    }
    
    init(logger: Logger) {
        self.logger = logger
        self.appState = AppState(from: UIApplication.shared.applicationState)
    }
    
    public func start() {
        
        // Prevent registering self as an observer multiple times
        stop()
        
        self.shouldPostEvent = true
        
        self.appState = AppState(from: UIApplication.shared.applicationState)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appEnteredForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appEnteredBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appBecameActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appBecameInactive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        
        // Note: `UIApplication.willTerminateNotification` is only posted when the app is
        // terminated while running in the foreground (e.g., stopped from Xcode or on device shutdown).
        // On iOS 13+, it is NOT triggered if the app is backgrounded and then killed by the user
        // or by the system for memory pressure.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillTerminate),
            name: UIApplication.willTerminateNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceiveMemoryLowWarning),
            name: UIApplication.didReceiveMemoryWarningNotification,
            object: nil
        )
        
    }
    
    public func stop() {
        self.shouldPostEvent = false
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func appEnteredForeground() {
        self.appState = .foreground
    }

    @objc private func appEnteredBackground() {
        self.appState = .background
    }
    
    @objc private func appBecameActive() {
        self.appState = .active
    }
    
    @objc private func appBecameInactive() {
        self.appState = .inactive
    }
    
    @objc private func appWillTerminate() {
        self.appState = .terminated
    }
    
    @objc private func didReceiveMemoryLowWarning() {
        logger.info(msg: "Application received memory low warning.")
        self.delegate?.didReceiveMemoryWarning(monitor: self)
    }

    deinit {
        stop()
    }
}
