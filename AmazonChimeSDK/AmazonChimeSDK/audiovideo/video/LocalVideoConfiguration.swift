//
//  LocalVideoConfiguration.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// Configuration for a local video or content share to be sent
@objcMembers public class LocalVideoConfiguration: NSObject {

    /// The flag to disable/enable simulcast, default to true
    /// For local video use only, will not work for content share
    public var simulcastEnabled: Bool

    /// The max bit rate for video encoding, should be greater than 0
    /// Actual quality achieved may vary throughout the call depending on what system and network can provide
    public var maxBitRateKbps: UInt32

    public init(maxBitRateKbps: UInt32 = 0, simulcastEnabled: Bool = true) {
        self.maxBitRateKbps = maxBitRateKbps
        self.simulcastEnabled = simulcastEnabled
        super.init()
    }
}
