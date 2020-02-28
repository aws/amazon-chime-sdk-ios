//
//  ObservableMetric.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

/// ObservableMetric types are filtered from the various
/// metrics emitted by the underlying native clients
///
/// Send video metrics are only reported when sending
/// Receive video metrics are only reported when receiving
public enum ObservableMetric {
    case audioPacketsReceivedFractionLoss
    case audioPacketsSentFractionLoss
    /// Estimated uplink bandwidth (may not all be used)
    /// from perspective of video client
    case videoAvailableSendBandwidth
    /// Estimated downlink bandwidth (may not all be used)
    /// from perspective of video client
    case videoAvailableReceiveBandwidth
    /// Total bitrate summed accross all send streams
    case videoSendBitrate
    /// Total packet lost calculated across all send streams
    case videoSendPacketLostPercent
    /// Average send FPS across possibly multiple simulcast streams
    case videoSendFps
    /// Total bitrate summed across all receive streams
    case videoReceiveBitrate
    /// Total packet lost calculated across all receive streams
    case videoReceivePacketLostPercent
}
