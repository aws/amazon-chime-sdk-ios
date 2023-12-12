//
//  VideoBitrateConstants.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// video bitrates for regular and high-resolution meetings
@objc public class VideoBitrateConstants: NSObject {
    public let videoHighResolutionBitrateKbps:UInt32
    public let contentHighResolutionBitrateKbps:UInt32
    public override init() {
        self.videoHighResolutionBitrateKbps = 2500
        self.contentHighResolutionBitrateKbps = 2500
    }
}
