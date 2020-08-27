//
//  DefaultActiveSpeakerPolicy.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers public class DefaultActiveSpeakerPolicy: ActiveSpeakerPolicy {
    private let volumes = ConcurrentDictionary<String, Double>()
    private let speakerWeight: Double
    private let cutoffThreshold: Double
    private let takeoverRate: Double

    public init(
        speakerWeight: Double = 0.9,
        cutoffThreshold: Double = 0.01,
        takeoverRate: Double = 0.2
    ) {
        self.speakerWeight = speakerWeight
        self.cutoffThreshold = cutoffThreshold
        self.takeoverRate = takeoverRate
    }

    public func calculateScore(attendeeInfo: AttendeeInfo, volume: VolumeLevel) -> Double {
        var scalar: Double = 1.0
        if volume == VolumeLevel.muted || volume == VolumeLevel.notSpeaking {
            scalar = 0.0
        }
        let score = (volumes[attendeeInfo.attendeeId] ?? 0.0)
            * speakerWeight
            + scalar * (1 - speakerWeight)
        volumes[attendeeInfo.attendeeId] = score
        volumes.forEach { otherAttendeeId, _ in
            if otherAttendeeId != attendeeInfo.attendeeId,
                let otherAtttendeeVolume = volumes[otherAttendeeId]
            {
                volumes[otherAttendeeId] = max(
                    otherAtttendeeVolume - takeoverRate * scalar,
                    0.0
                )
            }
        }
        if score < cutoffThreshold {
            return 0.0
        }
        return score
    }

    public func prioritizeVideoSendBandwidthForActiveSpeaker() -> Bool {
        return true
    }
}
