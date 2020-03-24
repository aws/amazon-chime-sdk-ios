//
//  ObservableMetric.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `ObservableMetric` types represents filtered metrics that are intended to propagate to the
/// top level observers. All metrics are measured over the past second.
///
/// Send video metrics are only reported when sending.
/// Receive video metrics are only reported when receiving.
@objc public enum ObservableMetric: Int, CustomStringConvertible {
    /// Percentage of audio packets lost from server to client
    case audioReceivePacketLossPercent
    /// Percentage of audio packets lost from client to server
    case audioSendPacketLossPercent
    /// Estimated uplink bandwidth from perspective of video client
    case videoAvailableSendBandwidth
    /// Estimated downlink bandwidth from perspective of video client
    case videoAvailableReceiveBandwidth
    /// Sum of total bitrate across all send streams
    case videoSendBitrate
    /// Percentage of video packets lost from client to server across all send streams
    case videoSendPacketLossPercent
    /// Average send FPS across all send streams
    case videoSendFps
    /// Round trip time of packets sent from client to server
    case videoSendRttMs
    /// Sum of total bitrate across all receive streams
    case videoReceiveBitrate
    /// Percentage of video packets lost from server to client across all receive streams
    case videoReceivePacketLossPercent

    public var description: String {
        switch self {
        case .audioReceivePacketLossPercent:
            return "audioReceivePacketLossPercent"
        case .audioSendPacketLossPercent:
            return "audioSendPacketLossPercent"
        case .videoAvailableSendBandwidth:
            return "videoAvailableSendBandwidth"
        case .videoAvailableReceiveBandwidth:
            return "videoAvailableReceiveBandwidth"
        case .videoSendBitrate:
            return "videoSendBitrate"
        case .videoSendPacketLossPercent:
            return "videoSendPacketLossPercent"
        case .videoSendFps:
            return "videoSendFps"
        case .videoSendRttMs:
            return "videoSendRttMs"
        case .videoReceiveBitrate:
            return "videoReceiveBitrate"
        case .videoReceivePacketLossPercent:
            return "videoReceivePacketLossPercent"
        }
    }
}
