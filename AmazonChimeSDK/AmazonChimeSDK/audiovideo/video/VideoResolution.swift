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
    public let width: Int
    public let height: Int
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }

    /// Preset video resolutions (for customer to select).
    public static let high: VideoResolution = {
        return VideoResolution(width: 960, height: 720)
    }()
    public static let medium: VideoResolution = {
        return VideoResolution(width: 640, height: 480)
    }()
    public static let low: VideoResolution = {
        return VideoResolution(width: 320, height: 240)
    }()

    /// Video max resolutions for feature-based meeting
    ///  * videoDisabled means audio-only meeting
    ///  * videoResolutionHD is 720p resolution (1280x720)
    ///  * videoResolutionFHD is 1080p resolution (1920x1080)
    ///  * videoResolutionUHD is 4k resolution (3840x2160)
    public static let videoDisabled: VideoResolution = {
        return VideoResolution(width: 0, height: 0)
    }()

    public static let videoResolutionHD: VideoResolution = {
        return VideoResolution(width: 1280, height: 720)
    }()

    public static let videoResolutionFHD: VideoResolution = {
        return VideoResolution(width: 1920, height: 1080)
    }()

    public static let videoResolutionUHD: VideoResolution = {
        return VideoResolution(width: 3840, height: 2160)
    }()

    static func == (lhs: VideoResolution, rhs: VideoResolution) -> Bool {
        return lhs.width == rhs.width && lhs.height == rhs.height
    }
}
