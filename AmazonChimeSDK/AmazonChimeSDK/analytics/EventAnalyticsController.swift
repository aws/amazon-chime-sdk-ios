//
//  EventAnalyticsController.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `EventAnalyticsController` keeps track of events and notifies `EventAnalyticsObserver`.
/// An event describes the success and failure conditions for the meeting session.
@objc public protocol EventAnalyticsController {
    func publishEvent(name: EventName)

    /// Publish an event with updated `EventAttributes`
    ///
    /// - Parameters:
    ///   - name: Name of event to publish
    ///   - attributes: Attributes `EventAttributes` for that meeting event
    func publishEvent(name: EventName, attributes: [AnyHashable: Any])

    /// Push `MeetingHistoryEventName` to internal `MeetingStatsCollector` states to later pass to builders
    ///
    /// - Parameter historyEventName: History state to put in the meeting history
    func pushHistory(historyEventName: MeetingHistoryEventName)

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
