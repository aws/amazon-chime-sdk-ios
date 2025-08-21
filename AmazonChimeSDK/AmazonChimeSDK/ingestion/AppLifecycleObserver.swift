//
//  AppLifecycleObserver.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@objc public protocol AppLifecycleObserver {
    
    func startObserve()
    
    func stopObserve()
}
