//
//  DefaultClientMetricsCollector.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
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
                    metricsObserver.onMetricsReceive(metrics: cachedObservableMetrics)
                }
            }
        }
    }
}

extension DefaultClientMetricsCollector: ClientMetricsCollector {
    public func processAudioClientMetrics(metrics: [AnyHashable: Any]) {
        cachedObservableMetrics[ObservableMetric.audioPacketsSentFractionLossPercent]
            = metrics[AudioClientMetric.serverPostJbMic1sPacketsLostPercent.rawValue]
        cachedObservableMetrics[ObservableMetric.audioPacketsReceivedFractionLossPercent]
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
        cachedObservableMetrics[ObservableMetric.videoSendPacketLostPercent]
            = metrics[VideoClientMetric.videoSendPacketLostPercent.rawValue]
        cachedObservableMetrics[ObservableMetric.videoSendFps]
            = metrics[VideoClientMetric.videoSendFps.rawValue]
        cachedObservableMetrics[ObservableMetric.videoReceiveBitrate]
            = metrics[VideoClientMetric.videoReceiveBitrate.rawValue]
        cachedObservableMetrics[ObservableMetric.videoReceivePacketLostPercent]
            = metrics[VideoClientMetric.videoReceivePacketLostPercent.rawValue]
        maybeEmitMetrics()
    }

    public func subscribeToMetrics(observer: MetricsObserver) {
        metricsObservers.add(observer)
    }

    public func unsubscribeFromMetrics(observer: MetricsObserver) {
        metricsObservers.remove(observer)
    }
}
