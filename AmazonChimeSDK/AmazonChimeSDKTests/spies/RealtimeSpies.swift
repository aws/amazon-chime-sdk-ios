//
//  RealtimeSpies.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Foundation

class RealtimeControllerFacadeSpy: RealtimeControllerFacade {
    struct DataMessageObserverCall {
        let topic: String
        let observer: DataMessageObserver
    }

    struct SendDataMessageCall {
        let topic: String
        let data: Any
        let lifetimeMs: Int32
    }

    var realtimeLocalMuteCallCount = 0
    var realtimeLocalMuteReturn = false
    var realtimeLocalUnmuteCallCount = 0
    var realtimeLocalUnmuteReturn = false
    var realtimePlaybackMuteCallCount = 0
    var realtimePlaybackMuteReturn = false
    var realtimePlaybackUnmuteCallCount = 0
    var realtimePlaybackUnmuteReturn = false
    var addRealtimeObserverCalls: [RealtimeObserver] = []
    var removeRealtimeObserverCalls: [RealtimeObserver] = []
    var addRealtimeDataMessageObserverCalls: [DataMessageObserverCall] = []
    var removeRealtimeDataMessageObserverFromTopicCalls: [String] = []
    var realtimeSendDataMessageCalls: [SendDataMessageCall] = []
    var realtimeSendDataMessageError: Error?
    var realtimeSetVoiceFocusEnabledCalls: [Bool] = []
    var realtimeSetVoiceFocusEnabledReturn = false
    var realtimeIsVoiceFocusEnabledCallCount = 0
    var realtimeIsVoiceFocusEnabledReturn = false

    func realtimeLocalMute() -> Bool {
        realtimeLocalMuteCallCount += 1
        return realtimeLocalMuteReturn
    }

    func realtimeLocalUnmute() -> Bool {
        realtimeLocalUnmuteCallCount += 1
        return realtimeLocalUnmuteReturn
    }

    func realtimePlaybackMute() -> Bool {
        realtimePlaybackMuteCallCount += 1
        return realtimePlaybackMuteReturn
    }

    func realtimePlaybackUnmute() -> Bool {
        realtimePlaybackUnmuteCallCount += 1
        return realtimePlaybackUnmuteReturn
    }

    func addRealtimeObserver(observer: RealtimeObserver) {
        addRealtimeObserverCalls.append(observer)
    }

    func removeRealtimeObserver(observer: RealtimeObserver) {
        removeRealtimeObserverCalls.append(observer)
    }

    func addRealtimeDataMessageObserver(topic: String, observer: DataMessageObserver) {
        addRealtimeDataMessageObserverCalls.append(DataMessageObserverCall(topic: topic, observer: observer))
    }

    func removeRealtimeDataMessageObserverFromTopic(topic: String) {
        removeRealtimeDataMessageObserverFromTopicCalls.append(topic)
    }

    func realtimeSendDataMessage(topic: String, data: Any, lifetimeMs: Int32) throws {
        realtimeSendDataMessageCalls.append(SendDataMessageCall(topic: topic,
                                                               data: data,
                                                               lifetimeMs: lifetimeMs))
        if let error = realtimeSendDataMessageError { throw error }
    }

    func realtimeSetVoiceFocusEnabled(enabled: Bool) -> Bool {
        realtimeSetVoiceFocusEnabledCalls.append(enabled)
        return realtimeSetVoiceFocusEnabledReturn
    }

    func realtimeIsVoiceFocusEnabled() -> Bool {
        realtimeIsVoiceFocusEnabledCallCount += 1
        return realtimeIsVoiceFocusEnabledReturn
    }
}

class RealtimeObserverSpy: RealtimeObserver {
    var volumeDidChangeCalls: [[VolumeUpdate]] = []
    var signalStrengthDidChangeCalls: [[SignalUpdate]] = []
    var attendeesDidJoinCalls: [[AttendeeInfo]] = []
    var attendeesDidLeaveCalls: [[AttendeeInfo]] = []
    var attendeesDidDropCalls: [[AttendeeInfo]] = []
    var attendeesDidMuteCalls: [[AttendeeInfo]] = []
    var attendeesDidUnmuteCalls: [[AttendeeInfo]] = []

    func volumeDidChange(volumeUpdates: [VolumeUpdate]) { volumeDidChangeCalls.append(volumeUpdates) }
    func signalStrengthDidChange(signalUpdates: [SignalUpdate]) { signalStrengthDidChangeCalls.append(signalUpdates) }
    func attendeesDidJoin(attendeeInfo: [AttendeeInfo]) { attendeesDidJoinCalls.append(attendeeInfo) }
    func attendeesDidLeave(attendeeInfo: [AttendeeInfo]) { attendeesDidLeaveCalls.append(attendeeInfo) }
    func attendeesDidDrop(attendeeInfo: [AttendeeInfo]) { attendeesDidDropCalls.append(attendeeInfo) }
    func attendeesDidMute(attendeeInfo: [AttendeeInfo]) { attendeesDidMuteCalls.append(attendeeInfo) }
    func attendeesDidUnmute(attendeeInfo: [AttendeeInfo]) { attendeesDidUnmuteCalls.append(attendeeInfo) }
}

class TranscriptEventObserverSpy: TranscriptEventObserver {
    var transcriptEventDidReceiveCalls: [TranscriptEvent] = []

    func transcriptEventDidReceive(transcriptEvent: TranscriptEvent) {
        transcriptEventDidReceiveCalls.append(transcriptEvent)
    }
}
