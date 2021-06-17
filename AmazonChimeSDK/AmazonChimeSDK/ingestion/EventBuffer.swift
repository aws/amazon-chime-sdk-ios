//
//  EventBuffer.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `EventBuffer` defines storing and consuming of event data.
@objc public protocol EventBuffer {
    /// Add an item.
    /// - Parameter item: item to add
    func add(item: SDKEvent)

    /// Process the data in the buffer
    func process()
}
