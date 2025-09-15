//
//  AppStateMonitor.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@objc public protocol AppStateMonitor {
    
    var delegate: AppStateMonitorDelegate? { get set }
    
    var appState: AppState { get }
    
    func start()
    
    func stop()
    
    /// Retrieves the current battery level as a percentage (0.0 to 1.0)
    /// Returns nil if battery monitoring is not available or disabled
    func getBatteryLevel() -> NSNumber?
    
    /// Retrieves the current battery state
    /// Returns the UIDevice.BatteryState indicating charging status
    func getBatteryState() -> BatteryState
}
