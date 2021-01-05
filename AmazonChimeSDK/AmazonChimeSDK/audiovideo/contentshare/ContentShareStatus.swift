//
//  ContentShareStatus.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `ContentShareStatus` indicates a status received regarding the content share.
@objcMembers public class ContentShareStatus: NSObject {
    public let statusCode: ContentShareStatusCode

    public init(statusCode: ContentShareStatusCode) {
        self.statusCode = statusCode
    }
}
