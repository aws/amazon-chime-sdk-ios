//
//  VideoFrameBuffer.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `VideoFrameBuffer` is a buffer which contains a single video buffer's raw data.
/// Typically owned by a `VideoFrame` which includes additional metadata.
@objc public protocol VideoFrameBuffer {
    /// Width of the video frame in pixels.
    func width() -> Int

    /// Height of the video frame in pixels.
    func height() -> Int
}
