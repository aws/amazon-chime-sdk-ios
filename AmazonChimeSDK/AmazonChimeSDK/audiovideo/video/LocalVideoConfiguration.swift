//
//  LocalVideoConfiguration.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// Configuration for a local video or content share to be sent
@objcMembers public class LocalVideoConfiguration: NSObject {

    /// The flag to disable/enable simulcast, default to true
    public var simulcastEnabled: Bool
    
    convenience override public init() {
        self.init(simulcastEnabled: true)
    }
    
    public init(simulcastEnabled: Bool) {
        self.simulcastEnabled = simulcastEnabled
    }
}
