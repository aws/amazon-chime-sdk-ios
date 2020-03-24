//
//  ActiveSpeakerObserver.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `ActiveSpeakerObserver` handles event related to finding active speaker and corresponding scores
@objc public protocol ActiveSpeakerObserver {
    /// Uniquely identifies this observer
    @objc var observerId: String { get }
    /// Frequency of activeSpeakerScoreDidChange
    @objc optional var scoresCallbackIntervalMs: Int { get }
    /// Observes the active speaker scores at frequency scoresCallbackIntervalMs
    ///
    /// - Parameter scores: Active speaker scores for each attendee
    @objc optional func activeSpeakerScoreDidChange(scores: [AttendeeInfo: Double])
    /// Observes changes in list of active speakers
    ///
    /// - Parameter attendeeInfo: List of active speakers in decreasing order of score
    func activeSpeakerDidDetect(attendeeInfo: [AttendeeInfo])
}
