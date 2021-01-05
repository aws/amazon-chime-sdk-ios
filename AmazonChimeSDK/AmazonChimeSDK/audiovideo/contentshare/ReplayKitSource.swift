//
//  ReplayKitSource.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import ReplayKit

/// `ReplayKitSource` repackages `CMSampleBuffer` objects from ReplayKit into SDK
/// usable `VideoFrame` objects. It currently supports resending video frames to maintain a
/// minimum framerate.
///
/// It does not directly contain any system library calls that actually captures the screen.
/// Builders can use `InAppScreenCaptureSource`to share screen from only their application.
/// For device level screen broadcast, take a look at the `SampleHandler` in AmazonChimeSDKDemoBroadcast.
@objcMembers public class ReplayKitSource: VideoSource {
    // This will prioritize resolution over framerate.
    public var videoContentHint: VideoContentHint = .detail

    private let logger: Logger
    private let sinks = ConcurrentMutableSet()

    private lazy var videoFrameResender = VideoFrameResender(minFramerate: 5) { [weak self] (frame) -> Void in
        guard let `self` = self else { return }
        self.sendVideoFrame(frame: frame)
    }

    public init(logger: Logger) {
        self.logger = logger
    }

    public func stop() {
        videoFrameResender.stop()
    }

    public func addVideoSink(sink: VideoSink) {
        sinks.add(sink)
    }

    public func removeVideoSink(sink: VideoSink) {
        sinks.remove(sink)
    }

    public func processSampleBuffer(sampleBuffer: CMSampleBuffer, type: RPSampleBufferType) {
        switch type {
        case .video:
            processVideo(sampleBuffer: sampleBuffer)
        case .audioApp:
            // Amazon Chime SDK does not support passing app audio yet.
            break
        case .audioMic:
            // Microphone audio is passed through the app instead of the app extension.
            break
        @unknown default:
            // Unknown sample buffer types will not be handled.
            break
        }
    }

    private func processVideo(sampleBuffer: CMSampleBuffer) {
        guard let frame = VideoFrame(sampleBuffer: sampleBuffer) else {
            logger.error(msg: "ReplayKitSource could not convert captured CMSampleBuffer to video frame")
            return
        }
        sendVideoFrame(frame: frame)
    }

    private func sendVideoFrame(frame: VideoFrame) {
        sinks.forEach { item in
            guard let sink = item as? VideoSink else { return }
            sink.onVideoFrameReceived(frame: frame)
        }
        videoFrameResender.frameDidSend(videoFrame: frame)
    }
}
