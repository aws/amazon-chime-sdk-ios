//
//  InAppCustomScreenCaptureSource.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import AmazonChimeSDKMedia
import Foundation
import ReplayKit

@available(iOS 11.0, *)
@objcMembers class InAppCustomScreenCaptureSource: NSObject, VideoCaptureSource, RPScreenRecorderDelegate {
    // This will prioritize resolution over framerate.
    public var videoContentHint: VideoContentHint = .text

    private let logger: Logger
    private let observers = ConcurrentMutableSet()
    private let sinks = ConcurrentMutableSet()
    private let context = CIContext()
    private var bufferPool: CVPixelBufferPool?
    private var bufferPoolWidth: Int = 0
    private var bufferPoolHeight: Int = 0

    private var playing: Bool = false
    private var restarting: Bool = false
    
    private var screenRecorder: RPScreenRecorder {
        return RPScreenRecorder.shared()
    }
    // Use an internal source so that logic can be shared with ReplayKit broadcast sources.
    private let replayKitSource: ReplayKitSource

    public init(logger: Logger) {
        self.logger = logger
        replayKitSource = ReplayKitSource(logger: logger)
        super.init()
        self.screenRecorder.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    deinit {
        self.screenRecorder.delegate = nil
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func appDidEnterForeground() {
        // If it failed to restart or was playing try to restart
        if (self.playing || self.restarting) {
            restart()
        }
    }
    
    private func restart() {
        print("Logging_RPScreenRecorder restarting...")
        self.restarting = true
        self.stop()
    }
    
    public func setRecorderDelegate(delegate: RPScreenRecorderDelegate) {
        self.screenRecorder.delegate = delegate
    }

    public func start() {
        screenRecorder.startCapture(handler: { [weak self] sampleBuffer, sampleBufferType, error in
            guard let self else { return }
            if error != nil {
                print("Logging_RPScreenRecorder capture error received: \(error.debugDescription)")
                self.logger.error(msg: "RPScreenRecorder capture error received: \(error.debugDescription)")
            } else {
                //print("Logging_RPScreenRecorder processing sample buffer:")
                self.replayKitSource.processSampleBuffer(sampleBuffer: sampleBuffer, type: sampleBufferType)
            }
        }, completionHandler: { [weak self] error in
            guard let self else { return }
            if let error = error {
                print("Logging_RPScreenRecorder start failed: \(error.localizedDescription)")
                self.logger.error(msg: "RPScreenRecorder start failed: \(error.localizedDescription)" )

                if self.restarting {
                    // Since it is restarting, we can background and foreground to start again so don't stop content share completely.
                    return
                }
                ObserverUtils.forEach(observers: self.observers) { (observer: CaptureSourceObserver) in
                    observer.captureDidFail(error: .systemFailure)
                }
            } else {
                self.restarting = false
                self.playing = true
                print("Logging_RPScreenRecorder start succeeded.")
                self.logger.info(msg: "RPScreenRecorder start succeeded.")
                ObserverUtils.forEach(observers: self.observers) { (observer: CaptureSourceObserver) in
                    observer.captureDidStart()
                }
            }
        })
    }

    public func stop() {
        if !screenRecorder.isRecording {
            self.playing = false
            print("Logging_RPScreenRecorder not recording, so skipping stop.")
            logger.info(msg: "RPScreenRecorder not recording, so skipping stop")
            if self.restarting {
                logger.info(msg: "RPScreenRecorder not recording, so skipping stop")
                self.start()
                return
            }
            self.notifyRecordingStopped()
            return
        }
        screenRecorder.stopCapture { [weak self] error in
            guard let self else { return }
            self.playing = false
            
            if self.restarting {
                self.start()
                return
            }
            
            if let error = error {
                print("Logging_RPScreenRecorder stop failed: \(error.localizedDescription)")
                self.logger.error(msg: "RPScreenRecorder stop failed: \(error.localizedDescription)")
                ObserverUtils.forEach(observers: self.observers) { (observer: CaptureSourceObserver) in
                    observer.captureDidFail(error: .systemFailure)
                }
            } else {
                print("Logging_RPScreenRecorder stop succeeded.")
                self.logger.info(msg: "RPScreenRecorder stop succeeded.")
                self.notifyRecordingStopped()
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
    
    private func notifyRecordingStopped() {
        ObserverUtils.forEach(observers: self.observers) { (observer: CaptureSourceObserver) in
            observer.captureDidStop()
        }
    }

}


@objcMembers class ObserverUtils: NSObject {
    public static func forEach<T>(
        observers: ConcurrentMutableSet,
        observerFunction: @escaping (_ observer: T) -> Void
    ) {
        DispatchQueue.main.async {
            observers.forEach { observer in
                if let observer = observer as? T {
                    observerFunction(observer)
                }
            }
        }
    }
}

@objcMembers class ConcurrentMutableSet {
    private let lock = NSRecursiveLock()
    private let set = NSMutableSet()
    var count: Int {
        return set.count
    }

    func add(_ object: Any) {
        lock.lock()
        defer { lock.unlock() }
        set.add(object)
    }

    func remove(_ object: Any) {
        lock.lock()
        defer { lock.unlock() }
        set.remove(object)
    }

    func removeAll() {
        lock.lock()
        defer { lock.unlock() }
        set.removeAllObjects()
    }

    func contains(_ object: Any) -> Bool {
        return set.contains(object)
    }

    func forEach(_ body: (Any) throws -> Void) rethrows {
        lock.lock()
        defer { lock.unlock() }
        try set.forEach(body)
    }
}
