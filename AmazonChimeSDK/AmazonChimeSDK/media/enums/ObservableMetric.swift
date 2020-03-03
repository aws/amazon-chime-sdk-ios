//
//  ObservableMetric.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

/// ObservableMetric types represents filtered metrics that are intended to propagate to the
/// top level observers. All metrics are measured over the past second.
///
/// Send video metrics are only reported when sending
/// Receive video metrics are only reported when receiving
@objc public enum ObservableMetric: Int, CustomStringConvertible {
    /// Percentage of audio packets lost from server to client
    case audioPacketsReceivedFractionLossPercent
    /// Percentage of audio packets lost from client to server
    case audioPacketsSentFractionLossPercent
    /// Estimated uplink bandwidth (may not all be used) from perspective of video client
    case videoAvailableSendBandwidth
    /// Estimated downlink bandwidth (may not all be used) from perspective of video client
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

    public var description: String {
        switch self {
        case .audioPacketsReceivedFractionLossPercent:
            return "audioPacketsReceivedFractionLossPercent"
        case .audioPacketsSentFractionLossPercent:
            return "audioPacketsSentFractionLossPercent"
        case .videoAvailableSendBandwidth:
            return "videoAvailableSendBandwidth"
        case .videoAvailableReceiveBandwidth:
            return "videoAvailableReceiveBandwidth"
        case .videoSendBitrate:
            return "videoSendBitrate"
        case .videoSendPacketLostPercent:
            return "videoSendPacketLostPercent"
        case .videoSendFps:
            return "videoSendFps"
        case .videoReceiveBitrate:
            return "videoReceiveBitrate"
        case .videoReceivePacketLostPercent:
            return "videoReceivePacketLostPercent"
        }
    }
}
