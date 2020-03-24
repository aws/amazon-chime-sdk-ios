//
//  DefaultClientMetricsCollector.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDKMedia
import Foundation

class DefaultClientMetricsCollector {
    private var cachedObservableMetrics: [ObservableMetric: Any] = [:]
    private var metricsObservers = NSMutableSet()
    private var lastEmittedMetricsTime = DispatchTime.now()
    private let metricsEmissionInterval = DispatchTimeInterval.seconds(1)

    private func maybeEmitMetrics() {
        let now = DispatchTime.now()
        let expectedMetricsEmmisionTime = lastEmittedMetricsTime + metricsEmissionInterval
        if now > expectedMetricsEmmisionTime {
            lastEmittedMetricsTime = now
            for observer in metricsObservers {
                if let metricsObserver = (observer as? MetricsObserver) {
                    metricsObserver.metricsDidReceive(metrics: cachedObservableMetrics)
                }
            }
        }
    }
}

extension DefaultClientMetricsCollector: ClientMetricsCollector {
    public func processAudioClientMetrics(metrics: [AnyHashable: Any]) {
        cachedObservableMetrics[ObservableMetric.audioSendPacketLossPercent]
            = metrics[AudioClientMetric.serverPostJbMic1sPacketsLostPercent.rawValue]
        cachedObservableMetrics[ObservableMetric.audioReceivePacketLossPercent]
            = metrics[AudioClientMetric.clientPostJbSpk1sPacketsLostPercent.rawValue]
        maybeEmitMetrics()
    }

    func processVideoClientMetrics(metrics: [AnyHashable: Any]) {
        cachedObservableMetrics[ObservableMetric.videoAvailableSendBandwidth]
            = metrics[VideoClientMetric.videoAvailableSendBandwidth.rawValue]
        cachedObservableMetrics[ObservableMetric.videoAvailableReceiveBandwidth]
            = metrics[VideoClientMetric.videoAvailableReceiveBandwidth.rawValue]
        cachedObservableMetrics[ObservableMetric.videoSendBitrate]
            = metrics[VideoClientMetric.videoSendBitrate.rawValue]
        cachedObservableMetrics[ObservableMetric.videoSendPacketLossPercent]
            = metrics[VideoClientMetric.videoSendPacketLossPercent.rawValue]
        cachedObservableMetrics[ObservableMetric.videoSendFps]
            = metrics[VideoClientMetric.videoSendFps.rawValue]
        cachedObservableMetrics[ObservableMetric.videoSendRttMs]
            = metrics[VideoClientMetric.videoSendRttMs.rawValue]
        cachedObservableMetrics[ObservableMetric.videoReceiveBitrate]
            = metrics[VideoClientMetric.videoReceiveBitrate.rawValue]
        cachedObservableMetrics[ObservableMetric.videoReceivePacketLossPercent]
            = metrics[VideoClientMetric.videoReceivePacketLossPercent.rawValue]
        maybeEmitMetrics()
    }

    public func subscribeToMetrics(observer: MetricsObserver) {
        metricsObservers.add(observer)
    }

    public func unsubscribeFromMetrics(observer: MetricsObserver) {
        metricsObservers.remove(observer)
    }
}
