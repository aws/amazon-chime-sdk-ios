//
//  VideoResolution.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// Customizable video resolution parameters for a remote video source.
@objc public class VideoResolution: NSObject {
    public var width: Int = 0
    public var height: Int = 0
    
    /// Preset video resolutions.
    public static let high: VideoResolution = {
        let res = VideoResolution()
        res.width = 960
        res.height = 720
        return res
    }()
    public static let medium: VideoResolution = {
        let res = VideoResolution()
        res.width = 640
        res.height = 480
        return res
    }()
    public static let low: VideoResolution = {
        let res = VideoResolution()
        res.width = 320
        res.height = 240
        return res
    }()
}
