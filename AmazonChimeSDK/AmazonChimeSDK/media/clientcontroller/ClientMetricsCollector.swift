//
//  ClientMetricsCollector.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

// ObservableMetric types are filtered from the various
// metrics emitted by the underlying native clients
public enum ObservableMetric {
    case audioPacketsReceivedFractionLoss
    case audioPacketsSentFractionLoss
}

// Maps to audio_metric_name_t
private enum AudioClientMetric: Int {
    case clientMicDeviceFramesLostPercent = 0
    case serverPreJbMicPacketsLostPercent = 1
    case serverMicMaxJitterMs = 2
    case serverPostJbMic1sPacketsLostPercent = 3
    case serverPostJbMic5sPacketsLostPercent = 4
    case clientPreJbSpkPacketsLostPercent = 5
    case clientSpkMaxJitterMs = 6
    case clientPostJbSpk1sPacketsLostPercent = 7
    case clientPostJbSpk5sPacketsLostPercent = 8
}

class ClientMetricsCollector {
    private var observers: NSMutableSet = NSMutableSet()
    private var cachedObservableMetrics: [ObservableMetric: Any] = [:]
    private var lastEmittedMetricsTime = DispatchTime.now()
    private let metricsEmissionIntervalMs = 1000
    private let nanosecondsPerMillisecond: UInt64 = 1000000

    static let sharedInstance = ClientMetricsCollector()

    public class func shared() -> ClientMetricsCollector {
        return sharedInstance
    }

    public func processAudioClientMetrics(metrics: [AnyHashable: Any]) {
        for (nativeMetricName, value) in metrics {
            if let nativeMetricValue = nativeMetricName as? Int,
                let metric = AudioClientMetric(rawValue: nativeMetricValue) {
                switch metric {
                case AudioClientMetric.serverPostJbMic1sPacketsLostPercent:
                    cachedObservableMetrics[ObservableMetric.audioPacketsSentFractionLoss] = value
                case AudioClientMetric.clientPostJbSpk1sPacketsLostPercent:
                    cachedObservableMetrics[ObservableMetric.audioPacketsReceivedFractionLoss] = value
                default: break // Non-observable metrics; ignore
                }
            }
        }

        maybeEmitMetrics()
    }

    private func maybeEmitMetrics() {
        let now = DispatchTime.now()
        let timeSinceLastMetricsEmmisionMs =
            (now.uptimeNanoseconds - lastEmittedMetricsTime.uptimeNanoseconds) / nanosecondsPerMillisecond
        if timeSinceLastMetricsEmmisionMs > metricsEmissionIntervalMs {
            lastEmittedMetricsTime = now
            for observer in observers {
                if let audioVideoObserver = (observer as? AudioVideoObserver) {
                    audioVideoObserver.onMetricsReceive(metrics: cachedObservableMetrics)
                }
            }
        }
    }

    public func addObserver(observer: AudioVideoObserver) {
        observers.add(observer)
    }

    public func removeObserver(observer: AudioVideoObserver) {
        observers.remove(observer)
    }
}
