//
//  VideoSubscriptionConfiguration.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers public class VideoSubscriptionConfiguration: NSObject {
    public var priority: Priority
    public var resolution: Resolution
    
    public init(priority: Priority, resolution: Resolution) {
        self.priority = priority
        self.resolution = resolution
    }
    
    static func ==(lhs: VideoSubscriptionConfiguration, rhs: VideoSubscriptionConfiguration) -> Bool {
        return lhs.priority == rhs.priority && lhs.resolution == rhs.resolution
    }
}
