//
//  Resolution.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objc public enum Resolution: Int {
    case low
    case medium
    case high
    
    public var width: Int {
        switch self {
        case .low:
            return 320
        case .medium:
            return 640
        case .high:
            return 960
        }
    }
    
    public var height: Int {
        switch self {
        case .low:
            return 240
        case .medium:
            return 480
        case .high:
            return 720
        }
    }
    
    public var targetBitrate: Int {
        switch self {
        case .low:
            return 300
        case .medium:
            return 600
        case .high:
            return 1200
        }
    }
}
