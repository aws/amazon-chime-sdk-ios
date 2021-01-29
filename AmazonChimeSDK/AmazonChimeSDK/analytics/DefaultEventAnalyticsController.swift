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

    init(meetingSessionConfig: MeetingSessionConfiguration,
         meetingStatsCollector: MeetingStatsCollector,
         logger: Logger) {
        self.meetingSessionConfig = meetingSessionConfig
        self.meetingStatsCollector = meetingStatsCollector
        self.logger = logger
        super.init()
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
             .meetingStartSucceeded:
            let meetingStats = meetingStatsCollector.getMeetingStats()
            mutatedAttributes.merge(meetingStats) { (_, newVal) in newVal }
        default:
            break
        }

        ObserverUtils.forEach(observers: eventAnalyticObservers) { (eventAnalyticObserver: EventAnalyticsObserver) in
            eventAnalyticObserver.eventDidReceive(name: name, attributes: mutatedAttributes)
        }
    }

    public func getMeetingHistory() -> [MeetingHistoryEvent] {
        return meetingStatsCollector.getMeetingHistory()
    }

    public func publishEvent(name: EventName) {
        self.publishEvent(name: name, attributes: [AnyHashable: Any]())
    }

    public func pushHistory(historyEventName: MeetingHistoryEventName) {
        self.meetingStatsCollector.addMeetingHistoryEvent(historyEventName: historyEventName,
                                                          timestampMs: DateUtils.getCurrentTimeStampMs())
    }

    public func addEventAnalyticsObserver(observer: EventAnalyticsObserver) {
        eventAnalyticObservers.add(observer)
    }

    public func removeEventAnalyticsObserver(observer: EventAnalyticsObserver) {
        eventAnalyticObservers.remove(observer)
    }

    public func getCommonEventAttributes() -> [AnyHashable : Any] {
        return [
            EventAttributeName.deviceName: DeviceUtils.deviceName,
            EventAttributeName.deviceManufacturer: DeviceUtils.manufacturer,
            EventAttributeName.deviceModel: DeviceUtils.deviceModel,
            EventAttributeName.osName: DeviceUtils.osName,
            EventAttributeName.osVersion: DeviceUtils.osVersion,
            EventAttributeName.sdkName: DeviceUtils.sdkName,
            EventAttributeName.sdkVersion: DeviceUtils.sdkVersion,
            EventAttributeName.mediaSdkVersion: DeviceUtils.mediaSDKVersion,
            EventAttributeName.meetingId: meetingSessionConfig.meetingId,
            EventAttributeName.externalMeetingId: meetingSessionConfig.externalMeetingId,
            EventAttributeName.attendeeId: meetingSessionConfig.credentials.attendeeId,
            EventAttributeName.externalUserId: meetingSessionConfig.credentials.externalUserId
        ] as [EventAttributeName: Any]
    }
}
