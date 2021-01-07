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
    private let metricsObservers = ConcurrentMutableSet()
    private var lastEmittedMetricsTime = DispatchTime.now()
    private let metricsEmissionInterval = DispatchTimeInterval.seconds(1)

    private func maybeEmitMetrics() {
        let now = DispatchTime.now()
        let expectedMetricsEmmisionTime = lastEmittedMetricsTime + metricsEmissionInterval
        if now > expectedMetricsEmmisionTime {
            lastEmittedMetricsTime = now
            ObserverUtils.forEach(observers: metricsObservers) { (metricsObserver: MetricsObserver) in
                metricsObserver.metricsDidReceive(metrics: self.cachedObservableMetrics)
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

    func processContentShareVideoClientMetrics(metrics: [AnyHashable: Any]) {
        // Currently, content share is send-only
        cachedObservableMetrics[ObservableMetric.contentShareVideoSendBitrate]
            = metrics[VideoClientMetric.videoSendBitrate.rawValue]
        cachedObservableMetrics[ObservableMetric.contentShareVideoSendPacketLossPercent]
            = metrics[VideoClientMetric.videoSendPacketLossPercent.rawValue]
        cachedObservableMetrics[ObservableMetric.contentShareVideoSendFps]
            = metrics[VideoClientMetric.videoSendFps.rawValue]
        cachedObservableMetrics[ObservableMetric.contentShareVideoSendRttMs]
            = metrics[VideoClientMetric.videoSendRttMs.rawValue]
        maybeEmitMetrics()
    }

    public func subscribeToMetrics(observer: MetricsObserver) {
        metricsObservers.add(observer)
    }

    public func unsubscribeFromMetrics(observer: MetricsObserver) {
        metricsObservers.remove(observer)
    }
}
