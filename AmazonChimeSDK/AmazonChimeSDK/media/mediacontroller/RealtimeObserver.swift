//
//  RealtimeObserver.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

@objc public protocol RealtimeObserver {
    /// Handles volume changes for attendees
    ///
    /// - Parameter volumeUpdates: An array of VolumeUpdates
    func onVolumeChange(volumeUpdates: [VolumeUpdate])

    /// Handles signal strength changes for attendees
    ///
    /// - Parameter signalUpdates: An array of SignalUpdates
    func onSignalStrengthChange(signalUpdates: [SignalUpdate])

    /// List attendees that are newly added to the meeting
    ///
    /// - Parameter attendeeInfo: an array of AttendeeInfo added
    func onAttendeesJoin(attendeeInfo: [AttendeeInfo])

    /// List attendees that left the meeting
    ///
    /// - Parameter attendeeInfo: an array of AttendeeInfo removed
    func onAttendeesLeave(attendeeInfo: [AttendeeInfo])

    /// List attendees that are newly muted in the meeting
    ///
    /// - Parameter attendeeInfo: an array of AttendeeInfo newly muted
    func onAttendeesMute(attendeeInfo: [AttendeeInfo])

    /// List attendees that newly unmuted from the meeting
    ///
    /// - Parameter attendeeInfo: an array of AttendeeInfo newly unmuted
    func onAttendeesUnmute(attendeeInfo: [AttendeeInfo])
}
