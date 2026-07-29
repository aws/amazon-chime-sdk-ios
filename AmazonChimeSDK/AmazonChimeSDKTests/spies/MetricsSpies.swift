//
//  MetricsSpies.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Foundation

class ClientMetricsCollectorSpy: ClientMetricsCollector {
    var processAudioClientMetricsCalls: [[AnyHashable: Any]] = []
    var processVideoClientMetricsCalls: [[AnyHashable: Any]] = []
    var processContentShareVideoClientMetricsCalls: [[AnyHashable: Any]] = []
    var subscribeToMetricsCalls: [MetricsObserver] = []
    var unsubscribeFromMetricsCalls: [MetricsObserver] = []

    func processAudioClientMetrics(metrics: [AnyHashable: Any]) {
        processAudioClientMetricsCalls.append(metrics)
    }

    func processVideoClientMetrics(metrics: [AnyHashable: Any]) {
        processVideoClientMetricsCalls.append(metrics)
    }

    func processContentShareVideoClientMetrics(metrics: [AnyHashable: Any]) {
        processContentShareVideoClientMetricsCalls.append(metrics)
    }

    func subscribeToMetrics(observer: MetricsObserver) {
        subscribeToMetricsCalls.append(observer)
    }

    func unsubscribeFromMetrics(observer: MetricsObserver) {
        unsubscribeFromMetricsCalls.append(observer)
    }
}

class MetricsObserverSpy: MetricsObserver {
    var metricsDidReceiveCalls: [[AnyHashable: Any]] = []

    func metricsDidReceive(metrics: [AnyHashable: Any]) {
        metricsDidReceiveCalls.append(metrics)
    }
}
