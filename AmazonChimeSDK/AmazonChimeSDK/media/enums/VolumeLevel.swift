//
//  VolumeLevel.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

/// VolumeLevel describes the volume level of an attendee for audio
public enum VolumeLevel: Int, CaseIterable {
    /// The attendee is muted
    case muted = -1

    /// The attendee is not speaking
    case notSpeaking = 0

    /// The attendee is speaking at low volume
    case low = 1

    /// The attendee is speaking at medium volume
    case medium = 2

    /// The attendee is speaking at high volume
    case high = 3
}
