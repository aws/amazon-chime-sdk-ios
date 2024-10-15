//
//  EventAnalyticsFacade.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `EventAnalyticsFacade` exposes event analytics related function to builders
@objc public protocol EventAnalyticsFacade {
    /// Subscribes to meeting event related data with an observer
    /// - Parameter observer: An observer to add to start receiving meeting events
    func addEventAnalyticsObserver(observer: EventAnalyticsObserver)

    /// Unsubscribes from meeting event by removing the specified observer
    /// - Parameter observer: An observer to remove to stop receiving meeting events
    func removeEventAnalyticsObserver(observer: EventAnalyticsObserver)

    /// Retrieve meeting history.
    func getMeetingHistory() -> [MeetingHistoryEvent]

    /// Retrieve common attributes, including deviceName, osName, and more.
    func getCommonEventAttributes() -> [AnyHashable: Any]
}
