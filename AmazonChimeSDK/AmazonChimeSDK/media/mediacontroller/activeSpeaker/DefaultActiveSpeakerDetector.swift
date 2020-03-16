//
//  DefaultActiveSpeakerDetector.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

/**
 * Implements the DefaultActiveSpeakerDetector with the [[ActiveSpeakerPolicy]]
 */
typealias DetectorCallback = (_ attendeeIds: [AttendeeInfo]) -> Void

@objcMembers public class DefaultActiveSpeakerDetector: ActiveSpeakerDetectorFacade, RealtimeObserver {
    private static var activityWaitIntervalMs = 1000
    private static var activityUpdateIntervalMs = 200

    private var speakerScores: [AttendeeInfo: Double] = [:]

    private var activeSpeakers: [AttendeeInfo] = []
    private var scoresTimers: [String: Scheduler] = [:]
    private var detectTimers: [String: Scheduler] = [:]
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
        self.audioClientObserver.subscribeToRealTimeEvents(observer: self)

        self.timer = IntervalScheduler(
            intervalMs: DefaultActiveSpeakerDetector.activityUpdateIntervalMs,
            callback: {
                self.policiesAndCallbacks.forEach {
                    for attendeeInfo in self.speakerScores.keys {
                        let lastTimestamp = self.mostRecentUpdateTimestamp[attendeeInfo] ?? 0
                        if Int(Date.timeIntervalSinceReferenceDate * 1000) - lastTimestamp > DefaultActiveSpeakerDetector.activityWaitIntervalMs {
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
        self.timer.start()
    }

    deinit {
        self.audioClientObserver.unsubscribeFromRealTimeEvents(observer: self)
        self.timer.stop()
    }

    private func needUpdateActiveSpeakers(attendeeInfo: AttendeeInfo) -> Bool {
        if self.activeSpeakers.isEmpty {
            return true
        }
        return (
            (self.speakerScores[attendeeInfo] == 0.0 && self.activeSpeakers.contains(attendeeInfo)) ||
                (self.speakerScores[attendeeInfo]! > 0.0 && !self.activeSpeakers.contains(attendeeInfo))
        )
    }

    private func updateActiveSpeakers(
        policy: ActiveSpeakerPolicy,
        callback: DetectorCallback,
        attendeeInfo: AttendeeInfo
    ) {
        if !self.needUpdateActiveSpeakers(attendeeInfo: attendeeInfo) {
            return
        }
        self.activeSpeakers = self.speakerScores.sorted(by: { $0.value > $1.value })
                                                .filter { $0.value > 0.0 }
                                                .map { $0.0 }
        callback(self.activeSpeakers)
        let selfIsActive =
            !self.activeSpeakers.isEmpty && self.activeSpeakers[0].attendeeId == self.selfAttendeeId
        let hasBandwidthPriority =
            selfIsActive && policy.prioritizeVideoSendBandwidthForActiveSpeaker()
        let hasBandwidthPriorityDidChange = self.hasBandwidthPriority != hasBandwidthPriority
        if hasBandwidthPriorityDidChange {
            self.hasBandwidthPriority = hasBandwidthPriority
            self.hasBandwidthPriorityCallback(hasBandwidthPriority: hasBandwidthPriority)
        }
    }

    private func updateScore(
        policy: ActiveSpeakerPolicy,
        callback: DetectorCallback,
        attendeeInfo: AttendeeInfo,
        volume: VolumeLevel
    ) {
        let activeScore = policy.calculateScore(attendeeInfo: attendeeInfo, volume: volume)
        if self.speakerScores[attendeeInfo] != activeScore {
            self.speakerScores[attendeeInfo] = activeScore
            self.updateActiveSpeakers(policy: policy, callback: callback, attendeeInfo: attendeeInfo)
        }
    }

    public func hasBandwidthPriorityCallback(hasBandwidthPriority: Bool) {}

    public func onSignalStrengthChange(signalUpdates: [SignalUpdate]) {}

    public func onAttendeesMute(attendeeInfo attendeeIds: [AttendeeInfo]) {}

    public func onAttendeesUnmute(attendeeInfo attendeeIds: [AttendeeInfo]) {}

    public func onVolumeChange(volumeUpdates attendeeVolumeMap: [VolumeUpdate]) {
        for volumeUpdate in attendeeVolumeMap {
            self.mostRecentUpdateTimestamp[volumeUpdate.attendeeInfo] = Int(Date.timeIntervalSinceReferenceDate * 1000.0)
            self.policiesAndCallbacks.forEach {
                self.updateScore(policy: $0.value.0,
                                 callback: $0.value.1,
                                 attendeeInfo: volumeUpdate.attendeeInfo,
                                 volume: volumeUpdate.volumeLevel)
            }
        }
    }

    public func onAttendeesJoin(attendeeInfo attendeeInfos: [AttendeeInfo]) {
        for attendeeInfo in attendeeInfos {
            self.speakerScores[attendeeInfo] = 0.0
            self.policiesAndCallbacks.forEach {
                self.updateActiveSpeakers(policy: $0.value.0, callback: $0.value.1, attendeeInfo: attendeeInfo)
            }
        }
    }

    public func onAttendeesLeave(attendeeInfo attendeeInfos: [AttendeeInfo]) {
        for attendeeInfo in attendeeInfos {
            self.speakerScores[attendeeInfo] = nil
            self.mostRecentUpdateTimestamp[attendeeInfo] = nil
            self.activeSpeakers.removeAll { $0 == attendeeInfo }
            self.policiesAndCallbacks.forEach {
                self.updateActiveSpeakers(policy: $0.value.0, callback: $0.value.1, attendeeInfo: attendeeInfo)
            }
        }
    }

    public func addActiveSpeakerObserver(
        policy: ActiveSpeakerPolicy,
        observer: ActiveSpeakerObserver
    ) {
        self.policiesAndCallbacks[observer.observerId] = (policy, observer.onActiveSpeakerDetect)

        if observer.onActiveSpeakerScoreChange(scores:) != nil, observer.scoresCallbackIntervalMs != nil {
            let scoresTimer = IntervalScheduler(intervalMs: observer.scoresCallbackIntervalMs!, callback: {
                observer.onActiveSpeakerScoreChange!(scores: self.speakerScores)
            })
            scoresTimer.start()
            self.scoresTimers[observer.observerId] = scoresTimer
        }
    }

    public func removeActiveSpeakerObserver(observer: ActiveSpeakerObserver) {
        if let scoresTimer = self.scoresTimers[observer.observerId] {
            scoresTimer.stop()
            self.scoresTimers[observer.observerId] = nil
        }

        if self.policiesAndCallbacks[observer.observerId] != nil {
            self.policiesAndCallbacks[observer.observerId] = nil
        }
    }
}
