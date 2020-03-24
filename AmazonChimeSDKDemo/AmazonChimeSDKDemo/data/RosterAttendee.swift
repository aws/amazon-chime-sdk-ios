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
    let name: String?
    let attendeeId: String
    var volume: VolumeLevel
    var signal: SignalStrength

    init(name: String?, attendeeId: String, volume: VolumeLevel, signal: SignalStrength) {
        self.name = name
        self.volume = volume
        self.signal = signal
        self.attendeeId = attendeeId
    }
}
