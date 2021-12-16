//
//  Constants.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDKMedia
import Foundation

@objcMembers class Constants: NSObject {
    static let maxSupportedVideoFrameRate = 15
    static let maxSupportedVideoHeight = 720
    static let maxSupportedVideoWidth = maxSupportedVideoHeight / 9 * 16
}

