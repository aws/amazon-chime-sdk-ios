//
//  DefaultActiveSpeakerPolicy.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers public class DefaultActiveSpeakerPolicy: ActiveSpeakerPolicy {
    private var volumes: [String: Double] = [:]
    private var speakerWeight: Double
    private var cutoffThreshold: Double
    private var takeoverRate: Double

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
        for (otherAttendeeId, _) in volumes where otherAttendeeId != attendeeInfo.attendeeId {
            volumes[otherAttendeeId] = max(
                volumes[otherAttendeeId]! - takeoverRate * scalar,
                0.0
            )
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
