//
//  AnalyticsSpies.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Foundation

class EventAnalyticsControllerSpy: EventAnalyticsController {
    struct PublishEventCall {
        let name: EventName
        let attributes: [AnyHashable: Any]?
        let notifyObservers: Bool?
    }

    var publishEventCalls: [PublishEventCall] = []
    var pushHistoryCalls: [MeetingHistoryEventName] = []
    var addEventAnalyticsObserverCalls: [EventAnalyticsObserver] = []
    var removeEventAnalyticsObserverCalls: [EventAnalyticsObserver] = []
    var getMeetingHistoryCallCount = 0
    var getMeetingHistoryReturn: [MeetingHistoryEvent] = []
    var getCommonEventAttributesCallCount = 0
    var getCommonEventAttributesReturn: [AnyHashable: Any] = [:]

    func publishEvent(name: EventName) {
        publishEventCalls.append(PublishEventCall(name: name, attributes: nil, notifyObservers: nil))
    }

    func publishEvent(name: EventName, attributes: [AnyHashable: Any]) {
        publishEventCalls.append(PublishEventCall(name: name, attributes: attributes, notifyObservers: nil))
    }

    func publishEvent(name: EventName, attributes: [AnyHashable: Any], notifyObservers: Bool) {
        publishEventCalls.append(PublishEventCall(name: name,
                                                 attributes: attributes,
                                                 notifyObservers: notifyObservers))
    }

    func pushHistory(historyEventName: MeetingHistoryEventName) {
        pushHistoryCalls.append(historyEventName)
    }

    func addEventAnalyticsObserver(observer: EventAnalyticsObserver) {
        addEventAnalyticsObserverCalls.append(observer)
    }

    func removeEventAnalyticsObserver(observer: EventAnalyticsObserver) {
        removeEventAnalyticsObserverCalls.append(observer)
    }

    func getMeetingHistory() -> [MeetingHistoryEvent] {
        getMeetingHistoryCallCount += 1
        return getMeetingHistoryReturn
    }

    func getCommonEventAttributes() -> [AnyHashable: Any] {
        getCommonEventAttributesCallCount += 1
        return getCommonEventAttributesReturn
    }
}

class EventAnalyticsObserverSpy: EventAnalyticsObserver {
    struct EventDidReceiveCall {
        let name: EventName
        let attributes: [AnyHashable: Any]
    }

    var eventDidReceiveCalls: [EventDidReceiveCall] = []

    func eventDidReceive(name: EventName, attributes: [AnyHashable: Any]) {
        eventDidReceiveCalls.append(EventDidReceiveCall(name: name, attributes: attributes))
    }
}

class MeetingStatsCollectorSpy: MeetingStatsCollector {
    struct AddMeetingHistoryEventCall {
        let historyEventName: MeetingHistoryEventName
        let timestampMs: Int64
    }

    var incrementRetryCountCallCount = 0
    var incrementPoorConnectionCountCallCount = 0
    var addMeetingHistoryEventCalls: [AddMeetingHistoryEventCall] = []
    var updateMaxVideoTileCalls: [Int] = []
    var updateMeetingStartConnectingTimeMsCallCount = 0
    var updateMeetingStartTimeMsCallCount = 0
    var updateMeetingStartReconnectingTimeMsCallCount = 0
    var updateMeetingReconnectedTimeMsCallCount = 0
    var resetMeetingStatsCallCount = 0
    var getMeetingStatsCallCount = 0
    var getMeetingStatsReturn: [AnyHashable: Any] = [:]
    var getMeetingHistoryCallCount = 0
    var getMeetingHistoryReturn: [MeetingHistoryEvent] = []

    func incrementRetryCount() { incrementRetryCountCallCount += 1 }
    func incrementPoorConnectionCount() { incrementPoorConnectionCountCallCount += 1 }

    func addMeetingHistoryEvent(historyEventName: MeetingHistoryEventName, timestampMs: Int64) {
        addMeetingHistoryEventCalls.append(AddMeetingHistoryEventCall(historyEventName: historyEventName,
                                                                     timestampMs: timestampMs))
    }

    func updateMaxVideoTile(videoTileCount: Int) { updateMaxVideoTileCalls.append(videoTileCount) }
    func updateMeetingStartConnectingTimeMs() { updateMeetingStartConnectingTimeMsCallCount += 1 }
    func updateMeetingStartTimeMs() { updateMeetingStartTimeMsCallCount += 1 }
    func updateMeetingStartReconnectingTimeMs() { updateMeetingStartReconnectingTimeMsCallCount += 1 }
    func updateMeetingReconnectedTimeMs() { updateMeetingReconnectedTimeMsCallCount += 1 }
    func resetMeetingStats() { resetMeetingStatsCallCount += 1 }

    func getMeetingStats() -> [AnyHashable: Any] {
        getMeetingStatsCallCount += 1
        return getMeetingStatsReturn
    }

    func getMeetingHistory() -> [MeetingHistoryEvent] {
        getMeetingHistoryCallCount += 1
        return getMeetingHistoryReturn
    }
}
