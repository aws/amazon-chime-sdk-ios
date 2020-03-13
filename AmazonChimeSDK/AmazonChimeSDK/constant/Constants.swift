//
//  Constants.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

@objcMembers class Constants: NSObject {
    static let modality = "#content"
    static let videoClientStatusCallAtCapacityViewOnly = 206
    // We only cares ERROR and FATAL, which are 5, 6 respectively
    static let errorLevel: UInt32 = LOGGER_ERROR.rawValue
    static let fatalLevel: UInt32 = LOGGER_FATAL.rawValue
}
