//
//  VideoCaptureSource.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `VideoCaptureSource` is an interface for various video capture sources (i.e. screen, camera, file) which can emit `VideoFrame` objects.
/// All the APIs in this protocol can be called regardless of whether the `MeetingSession.audioVideo` is started or not.
@objc public protocol VideoCaptureSource: VideoSource {
    /// Start capturing on this source and emitting video frames.
    func start()

    /// Stop capturing on this source and cease emitting video frames.
    func stop()

    /// Add a capture source observer to receive callbacks from the source on lifecycle events
    /// which can be used to trigger UI. This observer is entirely optional.
    /// - Parameters:
    ///   - observer: - New observer.
    func addCaptureSourceObserver(observer: CaptureSourceObserver)

    /// Remove a capture source observer.
    /// - Parameters:
    ///   - observer: - Observer to remove.
    func removeCaptureSourceObserver(observer: CaptureSourceObserver)
}
