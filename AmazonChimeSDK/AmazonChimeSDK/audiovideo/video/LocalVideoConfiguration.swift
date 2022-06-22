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
    /// only for localVideo, not work for content share
    public var simulcastEnabled: Bool = true
}
