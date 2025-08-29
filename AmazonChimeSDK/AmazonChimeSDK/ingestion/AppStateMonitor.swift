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
}
