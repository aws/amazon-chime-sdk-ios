//
//  AudioVideoControllerFacade.swift
//  SwiftTest
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

public protocol AudioVideoControllerFacade {
    var configuration: MeetingSessionConfiguration { get }
    var logger: Logger { get }
    /// Start AudioVideo Controller
    ///
    /// - Throws: `PermissionError.audioPermissionError` if `RecordPermission` is not given
    /// - Throws: `PermissionError.videoPermissionError` if video permission of `AVCaptureDevice` is not granted
    func start() throws

    /// Stop AudioVideo Controller. This will exit the meeting
    func stop()

    /// Enable self video to start streaming
    ///
    /// - Throws: `PermissionError.videoPermissionError` if video permission of `AVCaptureDevice` is not granted
    func startLocalVideo() throws

    /// Disable self video streaming
    func stopLocalVideo()

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
