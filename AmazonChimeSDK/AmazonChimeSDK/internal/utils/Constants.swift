//
//  Constants.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDKMedia
import Foundation

@objcMembers class Constants: NSObject {
    static let modality = "#content"
    static let videoClientStatusCallAtCapacityViewOnly = 206
    // We only cares ERROR and FATAL, which are 5, 6 respectively
    static let errorLevel: UInt32 = LOGGER_ERROR.rawValue
    static let fatalLevel: UInt32 = LOGGER_FATAL.rawValue
}
