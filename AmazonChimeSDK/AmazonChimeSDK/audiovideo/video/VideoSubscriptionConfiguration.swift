//
//  VideoSubscriptionConfiguration.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// Remote video source initialized with attendeeId and hashed by object address.
@objcMembers public class VideoSubscriptionConfiguration: NSObject {
    public var priority: VideoPriority = VideoPriority.highest
    public var resolution: VideoResolution = VideoResolution.high
}
