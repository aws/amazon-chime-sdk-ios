//
//  RealtimeObserver.swift
//  AmazonChimeSDK
//
//  Created by Hwang, Hokyung on 1/31/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

import Foundation

/// RealtimeObserver lets one listen to real time events such a volume or signal strength changes
public protocol RealtimeObserver {

    /// Handles volume changes for attendees
    ///
    /// - Parameter attendeeVolumeMap: A dictionary of attendee Ids to volume
    func onVolumeChange(attendeeVolumeMap: [String: Int])

    /// Handles signal strength changes for attendees
    /// 
    /// - Parameter attendeeSignalMap: A dictionary of attendee Ids to signal strength
    func onSignalStrengthChange(attendeeSignalMap: [String: Int])
}
