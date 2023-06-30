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
/// minimum frame rate.
///
/// It does not directly contain any system library calls that actually captures the screen.
/// Builders can use `InAppScreenCaptureSource`to share screen from only their application.
/// For device level screen broadcast, take a look at the `SampleHandler` in AmazonChimeSDKDemoBroadcast.
@objcMembers public class ReplayKitSource: VideoSource {
    // This will prioritize resolution over frame rate.
    public var videoContentHint: VideoContentHint = .detail

    private let logger: Logger
    private let sinks = ConcurrentMutableSet()
   
    private let resolutionMinConstraint: Int = 1080
    private let resolutionMaxConstraint: Int = 1920
    private var context:CIContext? = nil
    private var resizeFilter: CIFilter? = nil
    private var bufferPool: CVPixelBufferPool? = nil
    private var bufferPoolWidth: Int = 0
    private var bufferPoolHeight: Int = 0

    private lazy var videoFrameResender = VideoFrameResender(minFrameRate: 5) { [weak self] (frame) -> Void in
        guard let `self` = self else { return }
        self.sendVideoFrame(frame: frame)
    }

    public init(logger: Logger) {
        self.logger = logger
    }

    public func stop() {
        videoFrameResender.stop()
        context = nil
        resizeFilter = nil
        bufferPool = nil
        bufferPoolWidth = 0
        bufferPoolHeight = 0
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

    // create buffer with given dimension
    private func createBufferPool(newWidth: Int, newHeight: Int) -> CVPixelBufferPool? {
        var bufferPool: CVPixelBufferPool?
        var attributes: [NSString: NSObject] = [:]
        attributes[kCVPixelBufferPixelFormatTypeKey] =
            NSNumber(value: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange))
            attributes[kCVPixelBufferWidthKey] = NSNumber(value: newWidth)
            attributes[kCVPixelBufferHeightKey] = NSNumber(value: newHeight)
            attributes[kCVPixelBufferIOSurfacePropertiesKey] = [AnyHashable: Any]() as NSObject
        CVPixelBufferPoolCreate(nil, nil, attributes as CFDictionary?, &bufferPool)
        return bufferPool
    }

    // compute target resolution using input resolution and constraints
    private func computeTargetSize(inputWidth: Int, inputHeight: Int) -> CGSize {
        let minVal = min(inputWidth, inputHeight)
        let maxVal = max(inputWidth, inputHeight)
        let targetMinVal = resolutionMinConstraint
        let targetMaxVal = resolutionMaxConstraint
        var scaledWidth: Int
        var scaledHeight: Int
        if (minVal > targetMinVal || maxVal > targetMaxVal) {
            let minScale: Double = Double(minVal) / Double(targetMinVal)
            let maxScale: Double = Double(maxVal) / Double(targetMaxVal)
            if (minScale > maxScale) {
               if (minVal == inputWidth) {
                  scaledWidth = Int(targetMinVal)
                  scaledHeight = Int(Double(inputHeight) / Double(minScale))
               } else {
                  scaledHeight = Int(targetMinVal);
                  scaledWidth = Int(Double(inputWidth) / Double(minScale))
               }
            } else {
               if (maxVal == inputWidth) {
                  scaledWidth = Int(targetMaxVal);
                  scaledHeight = Int(Double(inputHeight) / Double(maxScale))
               } else {
                  scaledHeight = Int(targetMaxVal);
                  scaledWidth = Int(Double(inputWidth) / Double(maxScale))
               }
            }
        } else {
            scaledWidth = Int(inputWidth)
            scaledHeight = Int(inputHeight)
        }

        // alignment (8-byte)
        scaledWidth &= 0xfffffff8
        scaledHeight &= 0xfffffff8

        return CGSize(width: scaledWidth, height: scaledHeight)
    }

    private func processVideo(sampleBuffer: CMSampleBuffer) {
        let imageBuffer: CVImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        let imageWidth: Int = CVPixelBufferGetWidth(imageBuffer)
        let imageHeight: Int = CVPixelBufferGetHeight(imageBuffer)
        let minVal = min(imageWidth, imageHeight)
        let maxVal = max(imageWidth, imageHeight)
        guard let frame = VideoFrame(sampleBuffer: sampleBuffer) else {
            logger.error(msg: "ReplayKitSource could not convert captured CMSampleBuffer to video frame")
            return
        }
        if (minVal <= resolutionMinConstraint && maxVal <= resolutionMaxConstraint) {
            sendVideoFrame(frame: frame)
            return
        }

        // Create `VideoFramePixelBuffer` of the input frame.
        guard let pixelBuffer = frame.buffer as? VideoFramePixelBuffer else {
            sendVideoFrame(frame: frame)
            return
        }

        // CIImage of the input pixel buffer.
        let sourceImage:CIImage = CIImage(cvImageBuffer: pixelBuffer.pixelBuffer)

        // Desired output size
        let targetSize = computeTargetSize(inputWidth: Int(sourceImage.extent.width), inputHeight: Int(sourceImage.extent.height))

        // Compute scale and corrective aspect ratio
        let scale = targetSize.height / (sourceImage.extent.height)
        let aspectRatio = targetSize.width/((sourceImage.extent.width) * scale)
        if (resizeFilter == nil) {
            resizeFilter = CIFilter(name:"CILanczosScaleTransform")!
        }

        // Apply resizing
        guard let filter = resizeFilter else {
            sendVideoFrame(frame: frame)
            return
        }
        filter.setValue(sourceImage, forKey: kCIInputImageKey)
        filter.setValue(scale, forKey: kCIInputScaleKey)
        filter.setValue(aspectRatio, forKey: kCIInputAspectRatioKey)
        guard let outputImage = filter.outputImage else {
            sendVideoFrame(frame: frame)
            return
        }

        if (context == nil) {
            context = CIContext(options: [.cacheIntermediates: false])
        }

        // Create the final `CVPixelBuffer` for the output image.
        if ((bufferPool == nil) || (bufferPoolWidth != Int(sourceImage.extent.width)) || (bufferPoolHeight != Int(sourceImage.extent.height))) {
            bufferPool = createBufferPool(newWidth: Int(targetSize.width), newHeight: Int(targetSize.height))!
            bufferPoolWidth = Int(sourceImage.extent.width)
            bufferPoolHeight = Int(sourceImage.extent.height)
        }
        var mergedImageBuffer: CVPixelBuffer?
        CVPixelBufferPoolCreatePixelBuffer(nil, bufferPool!, &mergedImageBuffer)
        guard let validMergedImageBuffer = mergedImageBuffer else {
            sendVideoFrame(frame: frame)
            return
        }

        // Render the output CGImage image in the buffer.
        guard let renderContext = context else {
            sendVideoFrame(frame: frame)
            return
        }
        renderContext.render(outputImage, to: validMergedImageBuffer)

        let processedFrame = VideoFrame(timestampNs: frame.timestampNs,
                                        rotation: frame.rotation,
                                        buffer: VideoFramePixelBuffer(pixelBuffer: validMergedImageBuffer))

        sendVideoFrame(frame: processedFrame)
    }

    private func sendVideoFrame(frame: VideoFrame) {
        sinks.forEach { item in
            guard let sink = item as? VideoSink else { return }
            sink.onVideoFrameReceived(frame: frame)
        }
        videoFrameResender.frameDidSend(videoFrame: frame)
    }
}
