//
//  ClientMetricsCollector.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

public protocol ClientMetricsCollector {
    func processAudioClientMetrics(metrics: [AnyHashable: Any])
    func subscribeToClientStateChange(observer: AudioVideoObserver)
    func unsubscribeFromClientStateChange(observer: AudioVideoObserver)
}
