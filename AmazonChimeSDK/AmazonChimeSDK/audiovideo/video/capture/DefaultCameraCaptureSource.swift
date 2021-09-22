//
//  DefaultCameraCaptureSource.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AVFoundation
import Foundation
import UIKit

@objcMembers public class DefaultCameraCaptureSource: NSObject, CameraCaptureSource {
    public var videoContentHint: VideoContentHint = .motion
    private let logger: Logger
    private let cameraLock = NSLock()
    private let deviceType = AVCaptureDevice.DeviceType.builtInWideAngleCamera
    private let sinks = ConcurrentMutableSet()
    private let captureSourceObservers = ConcurrentMutableSet()
    private let output = AVCaptureVideoDataOutput()
    private let captureQueue = DispatchQueue(label: "captureQueue")
    private static let defaultCaptureFormat = VideoCaptureFormat(width: Constants.maxSupportedVideoWidth,
                                                                 height: Constants.maxSupportedVideoHeight,
                                                                 maxFrameRate: Constants.maxSupportedVideoFrameRate)

    private var session = AVCaptureSession()
    private var orientation = UIInterfaceOrientation.portrait
    private var captureDevice: AVCaptureDevice?
    private var eventAnalyticsController: EventAnalyticsController?

    public init(logger: Logger) {
        self.logger = logger
        super.init()

        device = MediaDevice.listVideoDevices().first { mediaDevice in
            mediaDevice.type == MediaDeviceType.videoFrontCamera
        }
        captureDevice = AVCaptureDevice.default(deviceType,
                                               for: .video,
                                               position: .front)

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(deviceOrientationDidChange),
                                       name: UIDevice.orientationDidChangeNotification,
                                       object: nil)
    }

    deinit {
        if torchEnabled {
            torchEnabled = false
        }
        if session.isRunning {
            session.stopRunning()
        }
        NotificationCenter.default.removeObserver(self)
    }

    public var device: MediaDevice? = MediaDevice.listVideoDevices().first {
        didSet {
            guard let device = device else { return }
            let isUsingFrontCamera = device.type == .videoFrontCamera
            captureDevice = AVCaptureDevice.default(deviceType,
                                                    for: .video,
                                                    position: isUsingFrontCamera ? .front : .back)
            if session.isRunning {
                start() // Restart
            }
        }
    }

    public var format: VideoCaptureFormat = defaultCaptureFormat {
        didSet {
            if captureDevice != nil, session.isRunning {
                start() // Restart
            }
        }
    }

    public var torchEnabled: Bool = false {
        didSet {
            if let captureDevice = captureDevice, torchAvailable {
                do {
                    try captureDevice.lockForConfiguration()
                    if torchEnabled {
                        captureDevice.torchMode = .on
                    } else {
                        captureDevice.torchMode = .off
                    }
                    captureDevice.unlockForConfiguration()
                } catch {
                    logger.error(msg: "Unable to set torch on current camera. Error: \(error.localizedDescription)")
                }
            } else {
                torchEnabled = false
                logger.info(msg: "Torch is not available on current camera.")
            }
        }
    }

    /// Expose current capture device's torch availability
    public var torchAvailable: Bool {
        guard let captureDevice = captureDevice else {
            return false
        }

        return captureDevice.hasTorch && captureDevice.isTorchAvailable
    }

    public func addVideoSink(sink: VideoSink) {
        sinks.add(sink)
    }

    public func removeVideoSink(sink: VideoSink) {
        sinks.remove(sink)
    }

    public func start() {
        cameraLock.lock()
        defer { cameraLock.unlock() }

        session = AVCaptureSession()
        guard let captureDevice = captureDevice else {
            return
        }
        session.beginConfiguration()

        guard let deviceInput = try? AVCaptureDeviceInput(device: captureDevice),
            session.canAddInput(deviceInput) else {
            session.commitConfiguration()
            handleCaptureFailed(reason: .configurationFailure)
            logger.error(msg: "DefaultCameraCaptureSource configuration failure")
            return
        }
        session.addInput(deviceInput)
        updateDeviceCaptureFormat()
        output.setSampleBufferDelegate(self, queue: captureQueue)

        if session.canAddOutput(output) {
            session.addOutput(output)
        } else {
            session.commitConfiguration()
            handleCaptureFailed(reason: .configurationFailure)
            logger.error(msg: "DefaultCameraCaptureSource configuration failure")
            return
        }
        session.commitConfiguration()
        updateOrientation()
        session.startRunning()

        // If the torch was currently on, starting the sessions
        // would turn it off. See if we can turn it back on.
        let currentTorchEnabled = torchEnabled
        self.torchEnabled = currentTorchEnabled

        ObserverUtils.forEach(observers: captureSourceObservers) { (observer: CaptureSourceObserver) in
            observer.captureDidStart()
        }
    }

    public func stop() {
        cameraLock.lock()
        defer { cameraLock.unlock() }

        session.stopRunning()

        // If the torch was currently on, stopping the sessions
        // would turn it off. See if we can turn it back on.
        let currentTorchEnabled = torchEnabled
        self.torchEnabled = currentTorchEnabled

        ObserverUtils.forEach(observers: captureSourceObservers) { (observer: CaptureSourceObserver) in
            observer.captureDidStop()
        }
    }

    public func switchCamera() {
        let isUsingFrontCamera = device?.type == .videoFrontCamera
        device = MediaDevice.listVideoDevices().first { mediaDevice in
            mediaDevice.type == (isUsingFrontCamera ? .videoBackCamera : .videoFrontCamera)
        }

        if device != nil {
            eventAnalyticsController?.pushHistory(historyEventName: .videoInputSelected)
        }
    }

    public func addCaptureSourceObserver(observer: CaptureSourceObserver) {
        captureSourceObservers.add(observer)
    }

    public func removeCaptureSourceObserver(observer: CaptureSourceObserver) {
        captureSourceObservers.remove(observer)
    }

    private func updateOrientation() {
        guard let connection = output.connection(with: AVMediaType.video) else {
            return
        }

        DispatchQueue.main.async {
            self.orientation = UIApplication.shared.statusBarOrientation

            switch self.orientation {
            case .portrait, .unknown:
                connection.videoOrientation = .portrait
            case .portraitUpsideDown:
                connection.videoOrientation = .portraitUpsideDown
            case .landscapeLeft:
                connection.videoOrientation = .landscapeLeft
            case .landscapeRight:
                connection.videoOrientation = .landscapeRight
            @unknown default:
                break
            }
        }
    }

    private func updateDeviceCaptureFormat() {
        guard let captureDevice = captureDevice else {
            return
        }
        // choose a supported format that is closest to `self.format`.
        try? captureDevice.lockForConfiguration()
        let newAVFormat = captureDevice.formats.min { avFormatA, avFormatB in
            let formatA = VideoCaptureFormat.fromAVCaptureDeviceFormat(format: avFormatA)
            let formatB = VideoCaptureFormat.fromAVCaptureDeviceFormat(format: avFormatB)
            let diffA = abs(formatA.width - format.width) + abs(formatA.height - format.height)
            let diffB = abs(formatB.width - format.width) + abs(formatB.height - format.height)
            return diffA < diffB
        }
        guard let chosenFormat = newAVFormat, chosenFormat != captureDevice.activeFormat else {
            captureDevice.unlockForConfiguration()
            return
        }
        captureDevice.activeFormat = chosenFormat
        captureDevice.unlockForConfiguration()
    }

    @objc private func deviceOrientationDidChange(notification: NSNotification) {
        captureQueue.async {
            self.updateOrientation()
        }
    }

    private func handleCaptureFailed(reason: CaptureSourceError) {
        let attributes = [
            EventAttributeName.videoInputError: reason
        ]

        eventAnalyticsController?.publishEvent(name: .videoInputFailed, attributes: attributes)

        ObserverUtils.forEach(observers: captureSourceObservers) { (observer: CaptureSourceObserver) in
            observer.captureDidFail(error: reason)
        }
    }

    public func setEventAnalyticsController(eventAnalyticsController: EventAnalyticsController?) {
        self.eventAnalyticsController = eventAnalyticsController
    }
}

extension DefaultCameraCaptureSource: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_: AVCaptureOutput,
                              didOutput sampleBuffer: CMSampleBuffer,
                              from _: AVCaptureConnection) {
        guard let frame = VideoFrame(sampleBuffer: sampleBuffer) else {
            handleCaptureFailed(reason: .invalidFrame)
            logger.error(msg: "DefaultCameraCaptureSource could not convert captured CMSampleBuffer to video frame")

            return
        }

        sinks.forEach { item in
            guard let sink = item as? VideoSink else { return }
            sink.onVideoFrameReceived(frame: frame)
        }
    }
}
