//
//  AppStateMonitorDelegate.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@objc public protocol AppStateMonitorDelegate: AnyObject {
    
    func appStateDidChange(monitor: AppStateMonitor, newAppState: AppState)
    
    func didReceiveMemoryWarning(monitor: AppStateMonitor)
}
