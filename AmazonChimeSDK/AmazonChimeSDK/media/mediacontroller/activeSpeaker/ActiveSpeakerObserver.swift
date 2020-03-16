//
//  ActiveSpeakerObserver.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

@objc public protocol ActiveSpeakerObserver {
    /// Uniquely identifies this observer
    @objc var observerId: String { get }
    /// Frequency of onActiveSpeakerScoreChange
    @objc optional var scoresCallbackIntervalMs: Int { get }
    /// Observes the active speaker scores at frequency scoresCallbackIntervalMs
    ///
    /// - Parameter scores: Active speaker scores for each attendee
    @objc optional func onActiveSpeakerScoreChange(scores: [AttendeeInfo: Double])
    /// Observes changes in list of active speakers
    ///
    /// - Parameter attendeeInfo: List of active speakers in decreasing order of score
    func onActiveSpeakerDetect(attendeeInfo: [AttendeeInfo])
}
