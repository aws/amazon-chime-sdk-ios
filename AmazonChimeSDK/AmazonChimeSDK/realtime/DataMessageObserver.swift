//
//  DataMessageObserver.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `DataMessasgeObserver` handles data message event,
@objc public protocol DataMessageObserver {
    /// Handles data message receive event
    ///
    /// Note: this callback will be called on main thread.
    ///
    /// - Parameter dataMessage: The data message received
    func dataMessageDidReceived(dataMessage: DataMessage)
}
