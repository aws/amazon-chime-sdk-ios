//
//  VideoCodecCapability.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers public class VideoCodecCapability: NSObject {
    public var name: String = ""
    public var clockRate: Int32 = 0
    public var parameters: [String: String] = [:]

    public init(name: String, clockRate: Int32, params: [String: String]) {
        self.name = name
        self.clockRate = clockRate
        self.parameters = params
    }

    public static func vp8() -> VideoCodecCapability {
        return VideoCodecCapability(name: "VP8", clockRate: 90000, params: [:])
    }

    public static func h264ConstrainedBaselineProfile() -> VideoCodecCapability {
        return VideoCodecCapability(
            name: "H264",
            clockRate: 90000,
            params: ["level-asymmetry-allowed": "1", "packetization-mode": "1", "profile-level-id": "42e034"]  // IOS uses profile 5.2 (0x34) for H264 CBP
        )
    }

    public static func vp9() -> VideoCodecCapability {
        return VideoCodecCapability(
            name: "VP9",
            clockRate: 90000,
            params: ["profile-id": "0"]
        )
    }
}
