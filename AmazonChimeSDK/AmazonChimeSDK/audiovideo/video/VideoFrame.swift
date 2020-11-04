//
//  VideoFrame.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `VideoFrame` is a class which contains a `VideoFrameBuffer` and metadata necessary for transmission.
/// Typically produced via a `VideoSource` and consumed via a `VideoSink`
@objcMembers public class VideoFrame: NSObject {
    /// Width of the video frame in pixels.
    public let width: Int

    /// Height of the video frame in pixels.
    public let height: Int

    /// Timestamp in nanoseconds at which the video frame was captured from some system monotonic clock.
    /// Will be aligned and converted to NTP (Network Time Protocol) within MediaSDK, which will then be converted to a system
    /// monotonic clock on remote end. May be different on frames emanated from MediaSDK.
    public let timestampNs: Int64

    /// Rotation of the video frame buffer in degrees clockwise from intended viewing horizon.
    ///
    /// e.g. If you were recording camera capture upside down relative to
    /// the orientation of the sensor, this value would be `VideoRotation.rotation180`.
    public let rotation: VideoRotation

    /// Object containing actual video frame data in some form.
    public let buffer: VideoFrameBuffer

    public init(timestampNs: Int64, rotation: VideoRotation, buffer: VideoFrameBuffer) {
        self.width = buffer.width()
        self.height = buffer.height()
        self.timestampNs = timestampNs
        self.rotation = rotation
        self.buffer = buffer
    }
}
