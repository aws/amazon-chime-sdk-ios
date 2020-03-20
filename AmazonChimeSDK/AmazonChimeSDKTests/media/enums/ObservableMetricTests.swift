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
        XCTAssertEqual(ObservableMetric.audioReceivePacketLossPercent.description,
                       "audioReceivePacketLossPercent")
        XCTAssertEqual(ObservableMetric.audioSendPacketLossPercent.description,
                       "audioSendPacketLossPercent")
        XCTAssertEqual(ObservableMetric.videoAvailableSendBandwidth.description, "videoAvailableSendBandwidth")
        XCTAssertEqual(ObservableMetric.videoAvailableReceiveBandwidth.description, "videoAvailableReceiveBandwidth")
        XCTAssertEqual(ObservableMetric.videoSendBitrate.description, "videoSendBitrate")
        XCTAssertEqual(ObservableMetric.videoSendPacketLossPercent.description, "videoSendPacketLossPercent")
        XCTAssertEqual(ObservableMetric.videoSendFps.description, "videoSendFps")
        XCTAssertEqual(ObservableMetric.videoReceiveBitrate.description, "videoReceiveBitrate")
        XCTAssertEqual(ObservableMetric.videoReceivePacketLossPercent.description, "videoReceivePacketLossPercent")
    }
}
