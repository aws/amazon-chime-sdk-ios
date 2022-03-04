//
//  VideoSubscriptionConfiguration.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// Configuration for a specific video source.
/// The values are intentionally mutable so that a map of all current configurations can be kept and updated as needed.
///
/// `VideoSubscriptionConfiguration` is used to contain the priority and resolution of
/// remote video sources and content share to be received
@objcMembers public class VideoSubscriptionConfiguration: NSObject {
    /// - Parameters:
    ///   - priority: Relative priority for the subscription.
    ///   - targetResolution: A target resolution for the subscription. The actual receive resolution may vary.
    public var priority: VideoPriority = VideoPriority.high
    public var targetResolution: VideoResolution = VideoResolution.high
}
