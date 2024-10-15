//
//  EventReporter.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `EventReporter` process data. It will be called in `DefaultEventAnalyticsController`.
@objc public protocol EventReporter {
    /// Process the event. For instance, in the default implementation, it will save it to Event Table.
    /// - Parameters:
    ///   - event: SDK related events
    func report(event: SDKEvent)

    /// Start the EventReporter
    func start()

    /// Stop the EventReporter
    func stop()
}
