//
//  ObservableMetricTests.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

@testable import AmazonChimeSDK
import XCTest

class ObservableMetricTests: XCTestCase {
    func testDescriptionShouldMatch() {
        XCTAssertEqual(ObservableMetric.audioPacketsReceivedFractionLossPercent.description,
                       "audioPacketsReceivedFractionLossPercent")
        XCTAssertEqual(ObservableMetric.audioPacketsSentFractionLossPercent.description,
                       "audioPacketsSentFractionLossPercent")
        XCTAssertEqual(ObservableMetric.videoAvailableSendBandwidth.description, "videoAvailableSendBandwidth")
        XCTAssertEqual(ObservableMetric.videoAvailableReceiveBandwidth.description, "videoAvailableReceiveBandwidth")
        XCTAssertEqual(ObservableMetric.videoSendBitrate.description, "videoSendBitrate")
        XCTAssertEqual(ObservableMetric.videoSendPacketLostPercent.description, "videoSendPacketLostPercent")
        XCTAssertEqual(ObservableMetric.videoSendFps.description, "videoSendFps")
        XCTAssertEqual(ObservableMetric.videoReceiveBitrate.description, "videoReceiveBitrate")
        XCTAssertEqual(ObservableMetric.videoReceivePacketLostPercent.description, "videoReceivePacketLostPercent")
    }
}
