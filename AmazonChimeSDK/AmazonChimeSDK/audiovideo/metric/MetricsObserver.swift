//
//  MetricsObserver.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `MetricsObserver` handles events related to audio/video metrics.
@objc public protocol MetricsObserver {
    /// Called when metrics are collected and ready
    ///
    /// - Parameter metrics: A dictionary of ObservableMetric case to value
    func metricsDidReceive(metrics: [AnyHashable: Any])
}
