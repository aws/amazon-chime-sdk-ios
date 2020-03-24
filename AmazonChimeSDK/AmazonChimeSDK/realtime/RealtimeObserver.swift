//
//  RealtimeObserver.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `RealtimeObserver` handles event that happens in realtime,
///  such as delta in attendees join or leave, volume/signal status.
@objc public protocol RealtimeObserver {
    /// Handles volume changes for attendees
    ///
    /// - Parameter volumeUpdates: An array of VolumeUpdates
    func volumeDidChange(volumeUpdates: [VolumeUpdate])

    /// Handles signal strength changes for attendees
    ///
    /// - Parameter signalUpdates: An array of SignalUpdates
    func signalStrengthDidChange(signalUpdates: [SignalUpdate])

    /// List attendees that are newly added to the meeting
    ///
    /// - Parameter attendeeInfo: an array of AttendeeInfo added
    func attendeesDidJoin(attendeeInfo: [AttendeeInfo])

    /// List attendees that left the meeting
    ///
    /// - Parameter attendeeInfo: an array of AttendeeInfo removed
    func attendeesDidLeave(attendeeInfo: [AttendeeInfo])

    /// List attendees that are newly muted in the meeting
    ///
    /// - Parameter attendeeInfo: an array of AttendeeInfo newly muted
    func attendeesDidMute(attendeeInfo: [AttendeeInfo])

    /// List attendees that newly unmuted from the meeting
    ///
    /// - Parameter attendeeInfo: an array of AttendeeInfo newly unmuted
    func attendeesDidUnmute(attendeeInfo: [AttendeeInfo])
}
