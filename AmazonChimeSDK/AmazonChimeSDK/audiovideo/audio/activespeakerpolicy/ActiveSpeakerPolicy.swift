//
//  ActiveSpeakerPolicy.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objc public protocol ActiveSpeakerPolicy {
    /// Return the score of the speaker. If the score is 0, this speaker is not active.
    ///
    /// - Parameter attendeeInfo: Attendee to calculate the score for
    /// - Parameter volume: Volume level of the speaker
    /// - Returns: The score of the speaker. The higher score, the more active the speaker.
    func calculateScore(attendeeInfo: AttendeeInfo, volume: VolumeLevel) -> Double
    /// Indicates whether the audio video controller is allowed to increase video send bandwidth
    /// for the currently active speaker if they have an active video tile. Set this to true, if
    /// your application makes the active speaker video tile larger than the other tiles.
    ///
    /// - Returns: Whether to prioritize video bandwidth for active speakers
    func prioritizeVideoSendBandwidthForActiveSpeaker() -> Bool
}
