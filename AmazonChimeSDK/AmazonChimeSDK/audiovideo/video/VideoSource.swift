//
//  VideoSource.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `VideoSource` is an interface for sources which produce video frames, and can send to a `VideoSink`.
/// Implementations can be passed to the `AudioVideoFacade` to be used as the video source sent to remote
/// participlants
@objc public protocol VideoSource {
    /// Content hint for downstream processing.
    var videoContentHint: VideoContentHint { get set }

    /// Add a video sink which will immediately begin to receive new frames.
    ///
    /// Multiple sinks can be added to a single `VideoSource` to allow forking of video frames,
    /// e.g. to send to both local preview and MediaSDK (for encoding) at the same time.
    /// 
    /// - Parameter sink: New video sink
    func addVideoSink(sink: VideoSink)

    /// Remove a video sink which will no longer receive new frames on return.
    ///
    /// - Parameter sink: Video sink to remove
    func removeVideoSink(sink: VideoSink)
}
