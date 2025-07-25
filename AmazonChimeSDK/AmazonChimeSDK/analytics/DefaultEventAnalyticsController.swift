//
//  DefaultEventAnalyticsController.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers public class DefaultEventAnalyticsController: NSObject, EventAnalyticsController {
    private var eventAnalyticObservers = ConcurrentMutableSet()
    private let meetingStatsCollector: MeetingStatsCollector
    private let meetingSessionConfig: MeetingSessionConfiguration
    private let logger: Logger
    private let eventReporter: EventReporter?

    init(meetingSessionConfig: MeetingSessionConfiguration,
         meetingStatsCollector: MeetingStatsCollector,
         logger: Logger,
         eventReporter: EventReporter?)
    {
        self.meetingSessionConfig = meetingSessionConfig
        self.meetingStatsCollector = meetingStatsCollector
        self.eventReporter = eventReporter
        self.logger = logger
        super.init()
    }

    convenience init(meetingSessionConfig: MeetingSessionConfiguration,
                     meetingStatsCollector: MeetingStatsCollector,
                     logger: Logger)
    {
        self.init(meetingSessionConfig: meetingSessionConfig,
                  meetingStatsCollector: meetingStatsCollector,
                  logger: logger,
                  eventReporter: nil)
    }

    public func publishEvent(name: EventName, attributes: [AnyHashable: Any]) {
        var mutatedAttributes = attributes
        let timestampMs = DateUtils.getCurrentTimeStampMs()
        mutatedAttributes[EventAttributeName.timestampMs] = timestampMs

        meetingStatsCollector.addMeetingHistoryEvent(historyEventName: Converters.MeetingEventName.toMeetingHistoryEventName(name: name),
                                                     timestampMs: timestampMs)

        switch name {
        case .meetingFailed,
             .meetingEnded,
             .meetingStartFailed,
             .meetingStartSucceeded,
             .meetingReconnected:
            let meetingStats = meetingStatsCollector.getMeetingStats()
            mutatedAttributes.merge(meetingStats) { _, newVal in newVal }
        default:
            break
        }

        eventReporter?.report(event: SDKEvent(eventName: name, eventAttributes: mutatedAttributes))

        ObserverUtils.forEach(observers: eventAnalyticObservers) { (eventAnalyticObserver: EventAnalyticsObserver) in
            eventAnalyticObserver.eventDidReceive(name: name, attributes: mutatedAttributes)
        }
    }

    public func getMeetingHistory() -> [MeetingHistoryEvent] {
        return meetingStatsCollector.getMeetingHistory()
    }

    public func publishEvent(name: EventName) {
        publishEvent(name: name, attributes: [AnyHashable: Any]())
    }

    public func pushHistory(historyEventName: MeetingHistoryEventName) {
        let currentTimeMs = DateUtils.getCurrentTimeStampMs()
        let attributes = [EventAttributeName.timestampMs: currentTimeMs]
        eventReporter?.report(event: SDKEvent(meetingHistoryEventName: historyEventName,
                                              eventAttributes: attributes))

        meetingStatsCollector.addMeetingHistoryEvent(historyEventName: historyEventName,
                                                     timestampMs: currentTimeMs)
    }

    public func addEventAnalyticsObserver(observer: EventAnalyticsObserver) {
        eventAnalyticObservers.add(observer)
    }

    public func removeEventAnalyticsObserver(observer: EventAnalyticsObserver) {
        eventAnalyticObservers.remove(observer)
    }

    public func getCommonEventAttributes() -> [AnyHashable: Any] {
        return EventAttributeUtils.getCommonAttributes(meetingSessionConfig: meetingSessionConfig)
    }
}
