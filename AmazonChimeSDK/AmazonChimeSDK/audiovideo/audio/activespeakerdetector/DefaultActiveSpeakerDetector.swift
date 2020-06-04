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
    private static let activityWaitIntervalMs = 1000
    private static let activityUpdateIntervalMs = 200

    private let speakerScores = ConcurrentDictionary<AttendeeInfo, Double>()
    private var activeSpeakers: [AttendeeInfo] = []
    private let scoresTimers = ConcurrentDictionary<String, Scheduler>()
    private var hasBandwidthPriority = false
    private let mostRecentUpdateTimestamp = ConcurrentDictionary<AttendeeInfo, Int>()
    private let audioClientObserver: AudioClientObserver
    private let selfAttendeeId: String
    private let policiesAndCallbacks = ConcurrentDictionary<String, (ActiveSpeakerPolicy, DetectorCallback)>()
    private var timer = IntervalScheduler(intervalMs: activityWaitIntervalMs, callback: {})

    public init(
        audioClientObserver: AudioClientObserver,
        selfAttendeeId: String
    ) {
        self.audioClientObserver = audioClientObserver
        self.selfAttendeeId = selfAttendeeId
        audioClientObserver.subscribeToRealTimeEvents(observer: self)

        timer = IntervalScheduler(
            intervalMs: DefaultActiveSpeakerDetector.activityUpdateIntervalMs,
            callback: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.policiesAndCallbacks.forEach { (_, policyAndCallback) in
                    strongSelf.speakerScores.forEach { (attendeeInfo, _) in
                        let lastTimestamp = strongSelf.mostRecentUpdateTimestamp[attendeeInfo] ?? 0
                        if Int(Double(DefaultActiveSpeakerDetector.activityWaitIntervalMs) *
                            Date.timeIntervalSinceReferenceDate) - lastTimestamp
                            > DefaultActiveSpeakerDetector.activityWaitIntervalMs {
                            strongSelf.updateScore(
                                policy: policyAndCallback.0,
                                callback: policyAndCallback.1,
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
        if self.hasBandwidthPriority != hasBandwidthPriority {
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

        if observer.activeSpeakerScoreDidChange(scores:) != nil,
            let scoresCallbackIntervalMs = observer.scoresCallbackIntervalMs {

            let scoresTimer = IntervalScheduler(intervalMs: scoresCallbackIntervalMs, callback: {
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { return }
                    observer.activeSpeakerScoreDidChange?(scores: strongSelf.speakerScores.getShallowDictCopy())
                }
            })
            scoresTimer.start()
            scoresTimers[observer.observerId] = scoresTimer
        }
    }

    public func removeActiveSpeakerObserver(observer: ActiveSpeakerObserver) {
        if let scoresTimer = scoresTimers[observer.observerId] {
            scoresTimer.stop()
            scoresTimers[observer.observerId] = nil
        }

        policiesAndCallbacks[observer.observerId] = nil
    }
}
