//
//  InAppScreenCaptureSource.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import ReplayKit

/// `InAppScreenCaptureSource` is used to share  screen capture within the app. When the app is in the background,
/// there is no sample sent to handler, and screen sharing is paused. `InAppScreenCaptureSource` is only available
/// on iOS 11+ because of `RPScreenRecorder.startCapture(handler:completionHandler:)` method.
/// `InAppScreenCaptureSource` does not support rotation while it's in progress. 
@available(iOS 11.0, *)
@objcMembers public class InAppScreenCaptureSource: NSObject, VideoCaptureSource {
    public var videoContentHint: VideoContentHint = .text

    private let logger: Logger
    private let observers = ConcurrentMutableSet()
    private let sinks = ConcurrentMutableSet()

    private var screenRecorder: RPScreenRecorder {
        return RPScreenRecorder.shared()
    }
    // Use an internal source so logic can be shared with ReplayKit broadcast sources
    private let replayKitSource: ReplayKitSource

    public init(logger: Logger) {
        self.logger = logger
        replayKitSource = ReplayKitSource(logger: logger)
    }

    public func start() {
        if screenRecorder.isRecording {
            stop()
        }
        screenRecorder.startCapture(handler: { [weak self] sampleBuffer, sampleBufferType, error in
            guard let `self` = self else { return }
            if error != nil {
                self.logger.error(msg: "RPScreenRecorder capture error received: \(error.debugDescription)")
            } else {
                self.replayKitSource.processSampleBuffer(sampleBuffer: sampleBuffer, type: sampleBufferType)
            }
        }, completionHandler: { [weak self] error in
            guard let `self` = self else { return }
            if let error = error {
                self.logger.error(msg: "RPScreenRecorder start failed: \(error.localizedDescription)" )
                ObserverUtils.forEach(observers: self.observers) { (observer: CaptureSourceObserver) in
                    observer.captureDidFail(error: .systemFailure)
                }
            } else {
                self.logger.info(msg: "RPScreenRecorder start succeeded.")
                ObserverUtils.forEach(observers: self.observers) { (observer: CaptureSourceObserver) in
                    observer.captureDidStart()
                }
            }
        })
    }

    public func stop() {
        if !screenRecorder.isRecording {
            logger.info(msg: "RPScreenRecorder not recording, so skipping stop")
            return
        }
        screenRecorder.stopCapture { [weak self] error in
            guard let `self` = self else { return }
            if let error = error {
                `self`.logger.error(msg: "RPScreenRecorder stop failed: \(error.localizedDescription)")
                ObserverUtils.forEach(observers: `self`.observers) { (observer: CaptureSourceObserver) in
                    observer.captureDidFail(error: .systemFailure)
                }
            } else {
                self.logger.info(msg: "RPScreenRecorder stop succeeded.")
                ObserverUtils.forEach(observers: `self`.observers) { (observer: CaptureSourceObserver) in
                    observer.captureDidStop()
                }
            }
        }
    }

    public func addVideoSink(sink: VideoSink) {
        replayKitSource.addVideoSink(sink: sink)
    }

    public func removeVideoSink(sink: VideoSink) {
        replayKitSource.removeVideoSink(sink: sink)
    }

    public func addCaptureSourceObserver(observer: CaptureSourceObserver) {
        observers.add(observer)
    }

    public func removeCaptureSourceObserver(observer: CaptureSourceObserver) {
        observers.remove(observer)
    }
}
