//
//  RosterAttendee.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import Foundation

public class RosterAttendee {
    let attendeeId: String
    let attendeeName: String?
    var volume: VolumeLevel
    var signal: SignalStrength
    var attendeeStatus: AttendeeStatus

    init(attendeeId: String, attendeeName: String, volume: VolumeLevel, signal: SignalStrength) {
        self.attendeeId = attendeeId
        self.attendeeName = attendeeName
        self.volume = volume
        self.signal = signal
        self.attendeeStatus = AttendeeStatus.joined
    }
}
