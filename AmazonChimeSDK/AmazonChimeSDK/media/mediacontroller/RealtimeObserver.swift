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
    /// - Parameter attendeeVolumeMap: A dictionary of attendee Ids to volume
    func onVolumeChange(attendeeVolumeMap: [String: Any])

    /// Handles signal strength changes for attendees
    ///
    /// - Parameter attendeeSignalMap: A dictionary of attendee Ids to signal strength
    func onSignalStrengthChange(attendeeSignalMap: [String: Any])

    /// List attendees that are newly added to the meeting
    ///
    /// - Parameter attendeeIds: ids of attendees added
    func onAttendeesJoin(attendeeIds: [String])

    /// List attendees that left the meeting
    ///
    /// - Parameter attendeeIds: ids of attendees removed
    func onAttendeesLeave(attendeeIds: [String])

    /// List attendees that are newly muted in the meeting
    ///
    /// - Parameter attendeeIds: ids of attendees newly muted
    func onAttendeesMute(attendeeIds: [String])

    /// List attendees that newly unmuted from the meeting
    ///
    /// - Parameter attendeeIds: ids of attendees newly unmuted
    func onAttendeesUnmute(attendeeIds: [String])
}
