//
//  ObservableMetricTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
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
        XCTAssertEqual(ObservableMetric.videoSendRttMs.description, "videoSendRttMs")
        XCTAssertEqual(ObservableMetric.videoReceiveBitrate.description, "videoReceiveBitrate")
        XCTAssertEqual(ObservableMetric.videoReceivePacketLossPercent.description, "videoReceivePacketLossPercent")
        XCTAssertEqual(ObservableMetric.contentShareVideoSendBitrate.description, "contentShareVideoSendBitrate")
        XCTAssertEqual(ObservableMetric.contentShareVideoSendPacketLossPercent.description, "contentShareVideoSendPacketLossPercent")
        XCTAssertEqual(ObservableMetric.contentShareVideoSendFps.description, "contentShareVideoSendFps")
        XCTAssertEqual(ObservableMetric.contentShareVideoSendRttMs.description, "contentShareVideoSendRttMs")
    }

    func testIsContentShareMetric() {
        XCTAssertFalse(ObservableMetric.audioReceivePacketLossPercent.isContentShareMetric)
        XCTAssertFalse(ObservableMetric.audioSendPacketLossPercent.isContentShareMetric)
        XCTAssertFalse(ObservableMetric.videoAvailableSendBandwidth.isContentShareMetric)
        XCTAssertFalse(ObservableMetric.videoAvailableReceiveBandwidth.isContentShareMetric)
        XCTAssertFalse(ObservableMetric.videoSendBitrate.isContentShareMetric)
        XCTAssertFalse(ObservableMetric.videoSendPacketLossPercent.isContentShareMetric)
        XCTAssertFalse(ObservableMetric.videoSendFps.isContentShareMetric)
        XCTAssertFalse(ObservableMetric.videoSendRttMs.isContentShareMetric)
        XCTAssertFalse(ObservableMetric.videoReceiveBitrate.isContentShareMetric)
        XCTAssertFalse(ObservableMetric.videoReceivePacketLossPercent.isContentShareMetric)
        XCTAssertTrue(ObservableMetric.contentShareVideoSendBitrate.isContentShareMetric)
        XCTAssertTrue(ObservableMetric.contentShareVideoSendPacketLossPercent.isContentShareMetric)
        XCTAssertTrue(ObservableMetric.contentShareVideoSendFps.isContentShareMetric)
        XCTAssertTrue(ObservableMetric.contentShareVideoSendRttMs.isContentShareMetric)
    }
}
