//
//  DefaultActiveSpeakerDetector.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/**
 * Implements the DefaultActiveSpeakerDetector with the `ActiveSpeakerPolicy`
 */
typealias DetectorCallback = (_ attendeeIds: [AttendeeInfo]) -> Void

@objcMembers public class DefaultActiveSpeakerDetector: ActiveSpeakerDetectorFacade, RealtimeObserver {
    private static var activityWaitIntervalMs = 1000
    private static var activityUpdateIntervalMs = 200

    private var speakerScores: [AttendeeInfo: Double] = [:]
    private var activeSpeakers: [AttendeeInfo] = []
    private var scoresTimers: [String: Scheduler] = [:]
    private var hasBandwidthPriority = false
    private var mostRecentUpdateTimestamp: [AttendeeInfo: Int] = [:]
    private var audioClientObserver: AudioClientObserver
    private var selfAttendeeId: String
    private var policiesAndCallbacks: [String: (ActiveSpeakerPolicy, DetectorCallback)] = [:]
    private var timer = IntervalScheduler(intervalMs: activityWaitIntervalMs, callback: {})

    init(
        audioClientObserver: AudioClientObserver,
        selfAttendeeId: String
    ) {
        self.audioClientObserver = audioClientObserver
        self.selfAttendeeId = selfAttendeeId
        audioClientObserver.subscribeToRealTimeEvents(observer: self)

        timer = IntervalScheduler(
            intervalMs: DefaultActiveSpeakerDetector.activityUpdateIntervalMs,
            callback: {
                self.policiesAndCallbacks.forEach {
                    for attendeeInfo in self.speakerScores.keys {
                        let lastTimestamp = self.mostRecentUpdateTimestamp[attendeeInfo] ?? 0
                        if Int(Double(DefaultActiveSpeakerDetector.activityWaitIntervalMs) *
                            Date.timeIntervalSinceReferenceDate) - lastTimestamp
                            > DefaultActiveSpeakerDetector.activityWaitIntervalMs {
                            self.updateScore(
                                policy: $0.value.0,
                                callback: $0.value.1,
                                attendeeInfo: attendeeInfo,
                                volume: VolumeLevel.notSpeaking
                            )
                        }
                    }
                }
            }
        )
        timer.start()
    }

    deinit {
        audioClientObserver.unsubscribeFromRealTimeEvents(observer: self)
        timer.stop()
    }

    private func needUpdateActiveSpeakers(attendeeInfo: AttendeeInfo) -> Bool {
        if activeSpeakers.isEmpty {
            return true
        }
        return activeSpeakers.contains(attendeeInfo) != (speakerScores[attendeeInfo] != nil
            && speakerScores[attendeeInfo]! > 0.0)
    }

    private func updateActiveSpeakers(
        policy: ActiveSpeakerPolicy,
        callback: @escaping DetectorCallback,
        attendeeInfo: AttendeeInfo
    ) {
        if !needUpdateActiveSpeakers(attendeeInfo: attendeeInfo) {
            return
        }
        /// Sort speaker scores and discard zeros
        activeSpeakers = speakerScores.sorted(by: { $0.value > $1.value })
            .filter { $0.value > 0.0 }
            .map { $0.0 }
        DispatchQueue.main.async {
            callback(self.activeSpeakers)
        }
        let selfIsActive =
            !activeSpeakers.isEmpty && activeSpeakers[0].attendeeId == selfAttendeeId
        let hasBandwidthPriority =
            selfIsActive && policy.prioritizeVideoSendBandwidthForActiveSpeaker()
        let hasBandwidthPriorityDidChange = hasBandwidthPriority != hasBandwidthPriority
        if hasBandwidthPriorityDidChange {
            self.hasBandwidthPriority = hasBandwidthPriority
            hasBandwidthPriorityCallback(hasBandwidthPriority: hasBandwidthPriority)
        }
    }

    private func updateScore(
        policy: ActiveSpeakerPolicy,
        callback: @escaping DetectorCallback,
        attendeeInfo: AttendeeInfo,
        volume: VolumeLevel
    ) {
        let activeScore = policy.calculateScore(attendeeInfo: attendeeInfo, volume: volume)
        if speakerScores[attendeeInfo] != activeScore {
            speakerScores[attendeeInfo] = activeScore
            updateActiveSpeakers(policy: policy, callback: callback, attendeeInfo: attendeeInfo)
        }
    }

    public func hasBandwidthPriorityCallback(hasBandwidthPriority: Bool) {}

    public func volumeDidChange(volumeUpdates: [VolumeUpdate]) {
        for volumeUpdate in volumeUpdates {
            mostRecentUpdateTimestamp[volumeUpdate.attendeeInfo]
                = Int(Date.timeIntervalSinceReferenceDate * Double(DefaultActiveSpeakerDetector.activityWaitIntervalMs))
            policiesAndCallbacks.forEach {
                updateScore(
                    policy: $0.value.0,
                    callback: $0.value.1,
                    attendeeInfo: volumeUpdate.attendeeInfo,
                    volume: volumeUpdate.volumeLevel
                )
            }
        }
    }

    public func signalStrengthDidChange(signalUpdates: [SignalUpdate]) { }

    private func removeAttendeesAndUpdate(attendeeInfo attendeeInfos: [AttendeeInfo]) {
        for attendeeInfo in attendeeInfos {
            speakerScores[attendeeInfo] = nil
            mostRecentUpdateTimestamp[attendeeInfo] = nil
            policiesAndCallbacks.forEach {
                updateActiveSpeakers(policy: $0.value.0, callback: $0.value.1, attendeeInfo: attendeeInfo)
            }
        }
    }

    public func attendeesDidLeave(attendeeInfo: [AttendeeInfo]) {
        removeAttendeesAndUpdate(attendeeInfo: attendeeInfo)
    }

    public func attendeesDidDrop(attendeeInfo: [AttendeeInfo]) {
        removeAttendeesAndUpdate(attendeeInfo: attendeeInfo)
    }

    public func attendeesDidMute(attendeeInfo: [AttendeeInfo]) { }

    public func attendeesDidUnmute(attendeeInfo: [AttendeeInfo]) { }

    public func attendeesDidJoin(attendeeInfo attendeeInfos: [AttendeeInfo]) {
        for attendeeInfo in attendeeInfos {
            speakerScores[attendeeInfo] = 0.0
            policiesAndCallbacks.forEach {
                updateActiveSpeakers(policy: $0.value.0, callback: $0.value.1, attendeeInfo: attendeeInfo)
            }
        }
    }

    public func addActiveSpeakerObserver(
        policy: ActiveSpeakerPolicy,
        observer: ActiveSpeakerObserver
    ) {
        policiesAndCallbacks[observer.observerId] = (policy, observer.activeSpeakerDidDetect)

        if observer.activeSpeakerScoreDidChange(scores:) != nil, observer.scoresCallbackIntervalMs != nil {
            let scoresTimer = IntervalScheduler(intervalMs: observer.scoresCallbackIntervalMs!, callback: {
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { return }
                    observer.activeSpeakerScoreDidChange!(scores: strongSelf.speakerScores)
                }
            })
            scoresTimer.start()
            scoresTimers[observer.observerId] = scoresTimer
        }
    }

    public func removeActiveSpeakerObserver(observer: ActiveSpeakerObserver) {
        if let scoresTimer = self.scoresTimers[observer.observerId] {
            scoresTimer.stop()
            scoresTimers[observer.observerId] = nil
        }

        if policiesAndCallbacks[observer.observerId] != nil {
            policiesAndCallbacks[observer.observerId] = nil
        }
    }
}
