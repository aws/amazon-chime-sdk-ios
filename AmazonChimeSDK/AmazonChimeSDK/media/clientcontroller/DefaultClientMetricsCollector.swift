//
//  DefaultClientMetricsCollector.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

class DefaultClientMetricsCollector {
    private var cachedObservableMetrics: [ObservableMetric: Any] = [:]
    private var clientStateObservers = NSMutableSet()
    private var lastEmittedMetricsTime = DispatchTime.now()
    private let metricsEmissionInterval = DispatchTimeInterval.seconds(1)

    private func maybeEmitMetrics() {
        let now = DispatchTime.now()
        let expectedMetricsEmmisionTime = lastEmittedMetricsTime + metricsEmissionInterval
        if now > expectedMetricsEmmisionTime {
            lastEmittedMetricsTime = now
            for observer in clientStateObservers {
                if let audioVideoObserver = (observer as? AudioVideoObserver) {
                    audioVideoObserver.onMetricsReceive(metrics: cachedObservableMetrics)
                }
            }
        }
    }
}

extension DefaultClientMetricsCollector: ClientMetricsCollector {
    public func processAudioClientMetrics(metrics: [AnyHashable: Any]) {
        for (nativeMetricName, value) in metrics {
            if let nativeMetricValue = nativeMetricName as? Int,
                let metric = AudioClientMetric(rawValue: nativeMetricValue) {
                switch metric {
                case AudioClientMetric.serverPostJbMic1sPacketsLostPercent:
                    cachedObservableMetrics[ObservableMetric.audioPacketsSentFractionLoss] = value
                case AudioClientMetric.clientPostJbSpk1sPacketsLostPercent:
                    cachedObservableMetrics[ObservableMetric.audioPacketsReceivedFractionLoss] = value
                default:
                    break
                }
            }
        }

        maybeEmitMetrics()
    }

    public func subscribeToClientStateChange(observer: AudioVideoObserver) {
        clientStateObservers.add(observer)
    }

    public func unsubscribeFromClientStateChange(observer: AudioVideoObserver) {
        clientStateObservers.remove(observer)
    }
}
