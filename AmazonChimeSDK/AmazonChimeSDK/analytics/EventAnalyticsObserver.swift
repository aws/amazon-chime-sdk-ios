//
//  EventAnalyticsObserver.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `EventAnalyticsObserver` handles events regarding to analytics.
@objc public protocol EventAnalyticsObserver {
    /// Called when specific events occur during the meeting and includes attributes of the event.
    /// This can be used to create analytics around meeting metric.
    /// - Parameters:
    ///   - name: name of the event
    ///   - attributes: attributes of the event
    func eventDidReceive(name: EventName, attributes: [AnyHashable: Any])
}
