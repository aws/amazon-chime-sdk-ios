//
//  ActiveSpeakerDetectorFacade.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `ActiveSpeakerDetectorFacade` listens to the volume indicator updates from the `RealtimeControllerFacade`.
/// It consults the `ActiveSpeakerPolicy` to determine if the speaker is active or not.
@objc public protocol ActiveSpeakerDetectorFacade {
    /// Starts the active speaker detector on the callback for the given policy.
    ///
    /// - Parameter policy: Handles Active Speaker implementation
    /// - Parameter observer: Observer that handles Active Speaker Events
    func addActiveSpeakerObserver(
        policy: ActiveSpeakerPolicy,
        observer: ActiveSpeakerObserver
    )

    /// Stops the active speaker detector callback from being called.
    ///
    /// - Parameter observer: Observer that handles Active Speaker Events
    func removeActiveSpeakerObserver(observer: ActiveSpeakerObserver)

    /// Handles bandwidth
    ///
    /// - Parameter hasBandwidthPriority: Tells the active speaker detector
    ///     whether or not to prioritize video bandwidth for active speakers
    func hasBandwidthPriorityCallback(hasBandwidthPriority: Bool)
}
