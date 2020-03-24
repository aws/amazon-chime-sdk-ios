//
//  DefaultActiveSpeakerPolicy.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
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
        let score = (self.volumes[attendeeInfo.attendeeId] ?? 0.0)
                     * self.speakerWeight
                     + scalar * (1 - self.speakerWeight)
        self.volumes[attendeeInfo.attendeeId] = score
        for (otherAttendeeId, _) in self.volumes where otherAttendeeId != attendeeInfo.attendeeId {
            self.volumes[otherAttendeeId] = max(
                self.volumes[otherAttendeeId]! - self.takeoverRate * scalar,
                0.0
            )
        }
        if score < self.cutoffThreshold {
            return 0.0
        }
        return score
    }

    public func prioritizeVideoSendBandwidthForActiveSpeaker() -> Bool {
        return true
    }
}
