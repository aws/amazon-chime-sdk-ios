//
//  SignalStrength.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

/// SignalStrength describes the signal strength of an attendee for audio
public enum SignalStrength: Int, CaseIterable {
    /// The attendee has no signal
    case none = 0

    /// The attendee has low signal
    case low = 1

    /// The attendee has high signal
    case high = 2
}
