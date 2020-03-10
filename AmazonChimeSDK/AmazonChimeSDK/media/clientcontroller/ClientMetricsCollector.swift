//
//  ClientMetricsCollector.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

/// ClientMetricsCollector takes the raw metrics from the native client,
/// consolidates them into a normalize map of ObservableMetric to value,
/// and eventually calls the OnReceiveMetric callback.
@objc public protocol ClientMetricsCollector {
    // A metric no longer being sent to process implies that it is no longer being reported
    // i.e. if an empty dictionary is processed for processVideoClientMetrics it can be
    // assumed that the video client has been stopped
    func processAudioClientMetrics(metrics: [AnyHashable: Any])
    func processVideoClientMetrics(metrics: [AnyHashable: Any])

    func subscribeToMetrics(observer: MetricsObserver)
    func unsubscribeFromMetrics(observer: MetricsObserver)
}
