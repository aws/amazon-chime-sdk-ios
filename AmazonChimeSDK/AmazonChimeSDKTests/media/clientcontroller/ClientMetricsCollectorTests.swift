//
//  ClientMetricsCollectorTests.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

@testable import AmazonChimeSDK
import XCTest

class ClientMetricsCollectorTests: XCTestCase, AudioVideoObserver {
    // Replicated here as to confirm values don't change and to avoid exposing in actual code
    private let clientMicDeviceFramesLostPercent = 0
    private let serverPostJbMic1sPacketsLostPercent = 3
    private let clientPostJbSpk1sPacketsLostPercent = 7

    private var receivedMetrics: [ObservableMetric: Any] = [:]

    func testOnMetricsReceiveShouldNotBeCalledBeforeInterval() {
        // Interval timer should start now
        let clientMetricsCollector = ClientMetricsCollector()
        clientMetricsCollector.addObserver(observer: self)

        let audioClientMetrics = [
            serverPostJbMic1sPacketsLostPercent: 1,
            clientPostJbSpk1sPacketsLostPercent: 2,
        ]
        clientMetricsCollector.processAudioClientMetrics(metrics: audioClientMetrics)

        // No callback should have occurred
        XCTAssertEqual(receivedMetrics.count, 0)
    }

    func testOnMetricsReceiveShouldBeCalledAfterInterval() {
        let clientMetricsCollector = ClientMetricsCollector()
        clientMetricsCollector.addObserver(observer: self)

        let audioClientMetrics = [
            serverPostJbMic1sPacketsLostPercent: 1,
            clientPostJbSpk1sPacketsLostPercent: 2,
        ]

        // Wait at least a second and next time we process metrics we should receive the callback
        Thread.sleep(forTimeInterval: 1)
        clientMetricsCollector.processAudioClientMetrics(metrics: audioClientMetrics)

        XCTAssertEqual(receivedMetrics.count, 2)
        XCTAssertEqual(receivedMetrics[ObservableMetric.audioPacketsSentFractionLoss] as? Int, 1)
        XCTAssertEqual(receivedMetrics[ObservableMetric.audioPacketsReceivedFractionLoss] as? Int, 2)
    }

    func testNonObservableMetricShouldNotBeEmitted() {
        let clientMetricsCollector = ClientMetricsCollector()
        clientMetricsCollector.addObserver(observer: self)

        let audioClientMetrics = [
            clientMicDeviceFramesLostPercent: 1,
        ]

        // Wait at least a second and next time we process metrics we should receive the callback
        Thread.sleep(forTimeInterval: 1)
        clientMetricsCollector.processAudioClientMetrics(metrics: audioClientMetrics)

        XCTAssertEqual(receivedMetrics.count, 0)
    }

    func testInvalidMetricShouldNotBeEmitted() {
        let clientMetricsCollector = ClientMetricsCollector()
        clientMetricsCollector.addObserver(observer: self)

        let audioClientMetrics = [
            999: 1,
        ]

        // Wait at least a second and next time we process metrics we should receive the callback
        Thread.sleep(forTimeInterval: 1)
        clientMetricsCollector.processAudioClientMetrics(metrics: audioClientMetrics)

        XCTAssertEqual(receivedMetrics.count, 0)
    }

    func onAudioVideoStartConnecting(reconnecting: Bool) {}
    func onAudioVideoStart(reconnecting: Bool) {}
    func onAudioVideoStop(sessionStatus: MeetingSessionStatus) {}
    func onAudioReconnectionCancel() {}
    func onConnectionRecover() {}
    func onConnectionBecomePoor() {}

    func onMetricsReceive(metrics: [ObservableMetric: Any]) {
        receivedMetrics = metrics
    }
}
