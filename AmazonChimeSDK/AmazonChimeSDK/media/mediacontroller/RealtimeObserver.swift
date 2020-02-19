//
//  RealtimeObserver.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

public protocol RealtimeObserver {
    /// Handles volume changes for attendees
    ///
    /// - Parameter attendeeVolumeMap: A dictionary of attendee Ids to volume
    func onVolumeChange(attendeeVolumeMap: [String: VolumeLevel])

    /// Handles signal strength changes for attendees
    ///
    /// - Parameter attendeeSignalMap: A dictionary of attendee Ids to signal strength
    func onSignalStrengthChange(attendeeSignalMap: [String: SignalStrength])
}
