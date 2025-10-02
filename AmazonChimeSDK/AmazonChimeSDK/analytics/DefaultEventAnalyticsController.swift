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
    private let appStateMonitor: AppStateMonitor
    private let meetingSessionConfig: MeetingSessionConfiguration
    private let logger: Logger
    private let eventReporter: EventReporter?

    init(meetingSessionConfig: MeetingSessionConfiguration,
         meetingStatsCollector: MeetingStatsCollector,
         appStateMonitor: AppStateMonitor,
         logger: Logger,
         eventReporter: EventReporter?)
    {
        self.meetingSessionConfig = meetingSessionConfig
        self.meetingStatsCollector = meetingStatsCollector
        self.appStateMonitor = appStateMonitor
        self.eventReporter = eventReporter
        self.logger = logger
        super.init()
    }

    convenience init(meetingSessionConfig: MeetingSessionConfiguration,
                     meetingStatsCollector: MeetingStatsCollector,
                     appStateMonitor: AppStateMonitor,
                     logger: Logger)
    {
        self.init(meetingSessionConfig: meetingSessionConfig,
                  meetingStatsCollector: meetingStatsCollector,
                  appStateMonitor: appStateMonitor,
                  logger: logger,
                  eventReporter: nil)
    }
    
    public func publishEvent(name: EventName) {
        publishEvent(name: name, attributes: [AnyHashable: Any](), notifyObservers: true)
    }
    
    public func publishEvent(name: EventName, attributes: [AnyHashable: Any]) {
        self.publishEvent(name: name, attributes: attributes, notifyObservers: true)
    }

    public func publishEvent(name: EventName, attributes: [AnyHashable: Any], notifyObservers: Bool) {
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
             .meetingReconnected,
             .videoClientSignalingDropped,
             .contentShareSignalingDropped:
            var meetingStats = meetingStatsCollector.getMeetingStats()
            if name != .meetingReconnected {
                meetingStats.removeValue(forKey: EventAttributeName.meetingReconnectDurationMs)
            }
            mutatedAttributes.merge(meetingStats) { _, newVal in newVal }
        default:
            break
        }
        
        mutatedAttributes.merge(getAppAttributes()) { (_, new) in new }

        eventReporter?.report(event: SDKEvent(eventName: name, eventAttributes: mutatedAttributes))
        
        if(notifyObservers) {
            ObserverUtils.forEach(observers: eventAnalyticObservers) { (eventAnalyticObserver: EventAnalyticsObserver) in
                eventAnalyticObserver.eventDidReceive(name: name, attributes: mutatedAttributes)
            }
        }
    }

    public func getMeetingHistory() -> [MeetingHistoryEvent] {
        return meetingStatsCollector.getMeetingHistory()
    }

    // TODO: Remove this, use publishEvent() instead
    public func pushHistory(historyEventName: MeetingHistoryEventName) {
        let currentTimeMs = DateUtils.getCurrentTimeStampMs()
        var attributes: [AnyHashable: Any]  = [
            EventAttributeName.timestampMs: currentTimeMs,
        ]
        attributes.merge(getAppAttributes()) { (_, new) in new }
        
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
    
    private func getAppAttributes() -> [AnyHashable: Any] {
        let appState = self.appStateMonitor.appState
        let batteryState = self.appStateMonitor.getBatteryState()
        let lowPowerModeEnabled = self.appStateMonitor.isLowPowerModeEnabled()
        var attributes: [EventAttributeName : Any] = [
            EventAttributeName.appState: appState,
            EventAttributeName.batteryState: batteryState,
            EventAttributeName.lowPowerModeEnabled: lowPowerModeEnabled
        ]
        
        if let batteryLevel = self.appStateMonitor.getBatteryLevel() {
            attributes[EventAttributeName.batteryLevel] = batteryLevel
        }
        
        return attributes
    }
}

extension DefaultEventAnalyticsController: AppStateMonitorDelegate {
    
    public func appStateDidChange(monitor: any AppStateMonitor, newAppState: AppState) {
        guard monitor === self.appStateMonitor else { return }
        self.publishEvent(name: .appStateChanged,
                          attributes: [EventAttributeName.appState: newAppState],
                          notifyObservers: false)
    }
    
    public func didReceiveMemoryWarning(monitor: any AppStateMonitor) {
        guard monitor === self.appStateMonitor else { return }
        self.publishEvent(name: .appMemoryLow, attributes: [:], notifyObservers: false)
    }
    
    
}
