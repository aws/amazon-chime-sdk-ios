//
//  VideoSink.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import CoreMedia
import Foundation

/// A `VideoSink` consumes video frames, typically from a `VideoSource`. It may process, fork, or render these frames.
/// Typically connected via video `VideoSource.addVideoSink` and disconnected via `VideoSource.removeVideoSink`
@objc public protocol VideoSink {
    /// Receive a video frame from some upstream source.
    /// The `VideoSink` may render, store, process, and forward the frame, among other applications.
    ///
    /// - Parameters:
    ///   - frame: New video frame to consume
    func onVideoFrameReceived(frame: VideoFrame)
}
