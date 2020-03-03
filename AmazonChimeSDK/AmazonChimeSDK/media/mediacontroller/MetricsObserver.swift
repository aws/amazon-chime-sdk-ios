//
//  MetricsObserver.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

@objc public protocol MetricsObserver {
    /// Called when metrics are collected and ready
    ///
    /// - Parameter metrics: A dictionary of ObservableMetric case to value
    func onMetricsReceive(metrics: [AnyHashable: Any])
}
