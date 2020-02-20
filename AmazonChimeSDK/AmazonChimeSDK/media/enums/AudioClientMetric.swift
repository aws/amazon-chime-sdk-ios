//
//  AudioClientMetric.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

// Maps to audio_metric_name_t
enum AudioClientMetric: Int {
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
