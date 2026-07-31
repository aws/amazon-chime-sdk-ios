//
//  VideoSpies.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Foundation

class VideoSinkSpy: VideoSink {
    var onVideoFrameReceivedCalls: [VideoFrame] = []
    /// Invoked on every received frame, for tests that need side effects.
    var onVideoFrameReceivedHandler: ((VideoFrame) -> Void)?

    func onVideoFrameReceived(frame: VideoFrame) {
        onVideoFrameReceivedCalls.append(frame)
        onVideoFrameReceivedHandler?(frame)
    }
}

class VideoRenderViewSpy: VideoRenderView {
    var onVideoFrameReceivedCalls: [VideoFrame] = []

    func onVideoFrameReceived(frame: VideoFrame) { onVideoFrameReceivedCalls.append(frame) }
}

class VideoSourceSpy: VideoSource {
    var videoContentHint: VideoContentHint = .none
    var addVideoSinkCalls: [VideoSink] = []
    var removeVideoSinkCalls: [VideoSink] = []

    func addVideoSink(sink: VideoSink) { addVideoSinkCalls.append(sink) }
    func removeVideoSink(sink: VideoSink) { removeVideoSinkCalls.append(sink) }
}

class CaptureSourceObserverSpy: CaptureSourceObserver {
    var captureDidStartCallCount = 0
    var captureDidStopCallCount = 0
    var captureDidFailCalls: [CaptureSourceError] = []

    func captureDidStart() { captureDidStartCallCount += 1 }
    func captureDidStop() { captureDidStopCallCount += 1 }
    func captureDidFail(error: CaptureSourceError) { captureDidFailCalls.append(error) }
}

class CameraCaptureSourceSpy: CameraCaptureSource {
    var device: MediaDevice?
    var torchEnabled = false
    var format: VideoCaptureFormat = VideoCaptureFormat(width: 0, height: 0, maxFrameRate: 0)
    var videoContentHint: VideoContentHint = .none

    var switchCameraCallCount = 0
    var startCallCount = 0
    var stopCallCount = 0
    var addCaptureSourceObserverCalls: [CaptureSourceObserver] = []
    var removeCaptureSourceObserverCalls: [CaptureSourceObserver] = []
    var addVideoSinkCalls: [VideoSink] = []
    var removeVideoSinkCalls: [VideoSink] = []

    func switchCamera() { switchCameraCallCount += 1 }
    func start() { startCallCount += 1 }
    func stop() { stopCallCount += 1 }

    func addCaptureSourceObserver(observer: CaptureSourceObserver) {
        addCaptureSourceObserverCalls.append(observer)
    }

    func removeCaptureSourceObserver(observer: CaptureSourceObserver) {
        removeCaptureSourceObserverCalls.append(observer)
    }

    func addVideoSink(sink: VideoSink) { addVideoSinkCalls.append(sink) }
    func removeVideoSink(sink: VideoSink) { removeVideoSinkCalls.append(sink) }
}

class VideoTileControllerSpy: VideoTileController {
    struct OnReceiveFrameCall {
        let frame: VideoFrame?
        let videoId: Int
        let attendeeId: String?
        let pauseState: VideoPauseState
    }

    struct BindVideoViewCall {
        let videoView: VideoRenderView
        let tileId: Int
    }

    var onReceiveFrameCalls: [OnReceiveFrameCall] = []
    var bindVideoViewCalls: [BindVideoViewCall] = []
    var unbindVideoViewCalls: [Int] = []
    var addVideoTileObserverCalls: [VideoTileObserver] = []
    var removeVideoTileObserverCalls: [VideoTileObserver] = []
    var pauseRemoteVideoTileCalls: [Int] = []
    var resumeRemoteVideoTileCalls: [Int] = []

    func onReceiveFrame(frame: VideoFrame?, videoId: Int, attendeeId: String?, pauseState: VideoPauseState) {
        onReceiveFrameCalls.append(OnReceiveFrameCall(frame: frame,
                                                     videoId: videoId,
                                                     attendeeId: attendeeId,
                                                     pauseState: pauseState))
    }

    func bindVideoView(videoView: VideoRenderView, tileId: Int) {
        bindVideoViewCalls.append(BindVideoViewCall(videoView: videoView, tileId: tileId))
    }

    func unbindVideoView(tileId: Int) { unbindVideoViewCalls.append(tileId) }
    func addVideoTileObserver(observer: VideoTileObserver) { addVideoTileObserverCalls.append(observer) }
    func removeVideoTileObserver(observer: VideoTileObserver) { removeVideoTileObserverCalls.append(observer) }
    func pauseRemoteVideoTile(tileId: Int) { pauseRemoteVideoTileCalls.append(tileId) }
    func resumeRemoteVideoTile(tileId: Int) { resumeRemoteVideoTileCalls.append(tileId) }
}
