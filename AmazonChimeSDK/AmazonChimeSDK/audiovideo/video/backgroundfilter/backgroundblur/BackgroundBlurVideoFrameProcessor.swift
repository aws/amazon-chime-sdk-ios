//
//  BackgroundBlurVideoFrameProcessor.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

#if canImport(AmazonChimeSDKMachineLearning)
import AmazonChimeSDKMachineLearning
#endif
import CoreImage
import UIKit

/// `BackgroundBlurVideoFrameProcessor` is a processor which receives video frames via `VideoSource` and
/// then applies Gaussian blur to each video frame and renders the foreground on top of the blurred image.
/// Gaussian blur is applied using built in `CIGaussianBlur` CIFilter.
@objcMembers public class BackgroundBlurVideoFrameProcessor: VideoSource, VideoSink {
    public var videoContentHint = VideoContentHint.motion

    /// Context used for processing and rendering the final output image.
    private let context = CIContext(options: [.cacheIntermediates: false])

    /// Set of `VideoSource` sinks.
    private let sinks = ConcurrentMutableSet()

    /// Blur strength value to adjust blur intensity.
    private var blurStrength: Int

    /// Background filter processor.
    private let backgroundFilterProcessor: BackgroundFilterProcessor

    /// Public constructor to initialize the processor.
    ///
    /// - Parameters:
    ///   - backgroundBlurConfiguration: `BackgroundBlurConfiguration` class.
    public init(backgroundBlurConfiguration: BackgroundBlurConfiguration) {
        self.blurStrength = backgroundBlurConfiguration.blurStrength.rawValue
        self.backgroundFilterProcessor = backgroundBlurConfiguration.backgroundFilterProcessor
    }

    /// Receive a video frame from some upstream source. The foreground is segmented and then masked
    /// on top of the blurred background.
    ///
    /// - Parameters:
    ///   - frame: New video frame to consume.
    public func onVideoFrameReceived(frame: VideoFrame) {
        var processedFrame: VideoFrame = frame

        // Update sinks at the end.
        defer {
            updateSinks(frame: processedFrame)
        }

        // Return the same frame if AmazonChimeSDKMachineLearning cannot be imported.
        #if !canImport(AmazonChimeSDKMachineLearning)
            backgroundFilterProcessor.logger.error(msg: "Unable to import AmazonChimeSDKMachineLearning framework." +
                         "See README for more information on how to import AmazonChimeSDKMachineLearning framework.")
            return
        #endif

        // Create `VideoFramePixelBuffer` of the input frame.
        guard let pixelBuffer = frame.buffer as? VideoFramePixelBuffer else {
            backgroundFilterProcessor.logger.debug(debugFunction: {
                return "VideoFramePixelBuffer was not found."
            })
            return
        }

        // CIImage of the input pixel buffer.
        let inputFrame = CIImage(cvImageBuffer: pixelBuffer.pixelBuffer)

        guard let inputCgFrame = context.createCGImage(inputFrame, from: inputFrame.extent) else {
            backgroundFilterProcessor.logger.error(msg: "Error creating CGImage of input frame.")
            return
        }

        // Retrieve the foreground alpha mask of the frame.
        guard let foregroundMask = backgroundFilterProcessor.createForegroundAlphaMask(inputFrameCG: inputCgFrame,
                                                                                       inputFrameCI: inputFrame)
        else {
            backgroundFilterProcessor.logger.error(msg: "Error retrieving the foreground alpha mask.")
            return
        }

        // Blur the input frame with Gaussian Blur which will be used as the background of the final output image.
        let backgroundBlurredImage: CIImage = inputFrame.clampedToExtent()
                                                        .applyingGaussianBlur(sigma: Double(blurStrength))
                                                        .clamped(to: inputFrame.extent)

        // Create the final output image by blending the alpha mask on top of the input frame to produce
        // the foreground image which is placed on top of the blurred background image.
        guard let outputImage: CIImage = backgroundFilterProcessor.blendWithWithAlphaMask(inputFrameCI: inputFrame,
                                                                                          maskImage: foregroundMask,
                                                                                          backgroundImage: backgroundBlurredImage)
        else {
            backgroundFilterProcessor.logger.error(msg: "Error producing the final output image.")
            return
        }

        // Create the final `CVPixelBuffer` for the output image.
        var mergedImageBuffer: CVPixelBuffer?
        guard let bufferPool = backgroundFilterProcessor.getBufferPool() else {
            backgroundFilterProcessor.logger.error(msg: "Error retrieving final buffer pool.")
            return
        }
        CVPixelBufferPoolCreatePixelBuffer(nil, bufferPool, &mergedImageBuffer)
        guard let validMergedImageBuffer = mergedImageBuffer else {
            backgroundFilterProcessor.logger.error(msg: "Error creating validMergedImageBuffer.")
            return
        }

        // Render the output CGImage image in the buffer.
        context.render(outputImage, to: validMergedImageBuffer)

        processedFrame = VideoFrame(timestampNs: frame.timestampNs,
                                    rotation: frame.rotation,
                                    buffer: VideoFramePixelBuffer(pixelBuffer: validMergedImageBuffer))
    }

    /// Allow builders to change the blur intensity value after initialization.
    ///
    /// - Parameters:
    ///   - newBlurStrength: New blur intensity value.
    public func setBlurStrength(newBlurStrength: BackgroundBlurStrength) {
        blurStrength = newBlurStrength.rawValue
    }

    /// Adds a video sink to the sinks set.
    public func addVideoSink(sink: VideoSink) {
        if !sinks.contains(sink) {
            sinks.add(sink)
        }
    }

    /// Remove a video sink from the sinks set.
    public func removeVideoSink(sink: VideoSink) {
        if sinks.contains(sink) {
            sinks.remove(sink)
        }
    }

    /// Update the `VideoSink(s)` with a new frame.
    ///
    /// - Parameters:
    ///    - frame: Next frame to render.
    public func updateSinks(frame: VideoFrame) {
        sinks.forEach({ sink in
            (sink as? VideoSink)?.onVideoFrameReceived(frame: frame)
        })
    }
}
