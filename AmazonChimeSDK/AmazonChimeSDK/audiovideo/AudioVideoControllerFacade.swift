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
    /// - Parameter audioVideoConfiguration: The configuration used for Audio & Video
    /// - Throws: `PermissionError.audioPermissionError` if `RecordPermission` is not given
    func start(audioVideoConfiguration: AudioVideoConfiguration) throws

    /// Start AudioVideo Controller
    ///
    /// - Parameter callKitEnabled: A Bool value to indicate whether the VoIP call to start has CallKit integration.
    /// This parameter is used to determine how audio session interruptions should be handled,
    /// in scenarios such as receving another phone call during the VoIP call.
    /// - Throws: `PermissionError.audioPermissionError` if `RecordPermission` is not given
    func start(callKitEnabled: Bool) throws

    /// Start AudioVideo Controller
    ///
    /// - Throws: `PermissionError.audioPermissionError` if `RecordPermission` is not given
    func start() throws

    /// Stop AudioVideo Controller. This will exit the meeting
    func stop()

    /// Start local video and begin transmitting frames from an internally held `DefaultCameraCaptureSource`.
    /// `stopLocalVideo` will stop the internal capture source if being used.
    ///
    /// Calling this after passing in a custom `VideoSource` will replace it with the internal capture source.
    ///
    /// This function will only have effect if `start` has already been called
    ///
    /// - Throws: `PermissionError.videoPermissionError` if video permission of `AVCaptureDevice` is not granted
    func startLocalVideo() throws

    /// Start local video with a provided custom `VideoSource` which can be used to provide custom
    /// `VideoFrame`s to be transmitted to remote clients. This will call `VideoSource.addVideoSink`
    /// on the provided source.
    ///
    /// Calling this function repeatedly will replace the previous `VideoSource` as the one being
    /// transmitted. It will also stop and replace the internal capture source if `startLocalVideo`
    /// was previously called with no arguments.
    ///
    /// This function will only have effect if `start` has already been called
    ///
    /// - Parameter source: The source of video frames to be sent to other clients
    func startLocalVideo(source: VideoSource)

    /// Stops sending video for local attendee. This will additionally stop the internal capture source if being used.
    /// If using a custom video source, this will call `VideoSource.removeVideoSink` on the previously provided source.
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
