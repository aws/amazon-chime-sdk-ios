//
//  AudioVideoControllerFacade.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `AudioVideoControllerFacade` manages the signaling and peer connections.
@objc public protocol AudioVideoControllerFacade {
    var configuration: MeetingSessionConfiguration { get }
    var logger: Logger { get }
    /// Start AudioVideo Controller
    ///
    /// - Throws: `PermissionError.audioPermissionError` if `RecordPermission` is not given
    func start() throws

    /// Stop AudioVideo Controller. This will exit the meeting
    func stop()

    /// Enable self video to start streaming
    ///
    /// - Throws: `PermissionError.videoPermissionError` if video permission of `AVCaptureDevice` is not granted
    func startLocalVideo() throws

    /// Disable self video streaming
    func stopLocalVideo()

    /// Enable remote video to start receiving streams
    func startRemoteVideo()

    /// Disable remote video to stop receiving streams
    func stopRemoteVideo()

    /// Subscribe to audio, video, and connection events with an `AudioVideoObserver`.
    ///
    /// - Parameter observer: The observer to subscribe to events with
    func addAudioVideoObserver(observer: AudioVideoObserver)

    /// Unsubscribes from audio, video, and connection events by removing specified `AudioVideoObserver`.
    ///
    /// - Parameter observer: The observer to unsubscribe from events with
    func removeAudioVideoObserver(observer: AudioVideoObserver)

    /// Subscribe to metrics events with an `MetricsObserver`.
    ///
    /// - Parameter observer: The observer to subscribe to events with
    func addMetricsObserver(observer: MetricsObserver)

    /// Unsubscribes from metrics events by removing specified `MetricsObserver`.
    ///
    /// - Parameter observer: The observer to unsubscribe from events with
    func removeMetricsObserver(observer: MetricsObserver)
}
