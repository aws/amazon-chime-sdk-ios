//
//  BackgroundReplacementVideoFrameProcessor.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import CoreImage
import Foundation
import UIKit

/// `BackgroundReplacementVideoFrameProcessor` is a processor which receives video frames via `VideoSource`
///  and then creates the foreground image which is rendered on top of a background image.
@objcMembers public class BackgroundReplacementVideoFrameProcessor: NSObject, VideoSource, VideoSink {
    public var videoContentHint = VideoContentHint.motion

    /// Context used for processing and rendering the final output image.
    private let context = CIContext(options: [.cacheIntermediates: false])

    /// Set of `VideoSource` sinks.
    private let sinks = ConcurrentMutableSet()

    /// Background replacement image.
    private var backgroundReplacementImage: CIImage?

    /// Background filter processor.
    private let backgroundFilterProcessor: BackgroundFilterProcessor

    /// Logger to log any warnings or errors.
    private let logger: Logger

    /// Public constructor to initialize the processor with a `BackgroundReplacementConfiguration`.
    ///
    /// - Parameters:
    ///   - backgroundReplacementConfiguration: `BackgroundReplacementConfiguration` class.
    public init(backgroundReplacementConfiguration: BackgroundReplacementConfiguration) {
        self.backgroundFilterProcessor = backgroundReplacementConfiguration.backgroundFilterProcessor
        self.logger = backgroundReplacementConfiguration.logger

        guard let backgroundReplacementImage = backgroundReplacementConfiguration.backgroundReplacementImage.cgImage
        else {
            logger.error(msg: "Failed to load CGImage of the provided background replacement image.")
            return
        }
        self.backgroundReplacementImage = CIImage(cgImage: backgroundReplacementImage)
    }

    /// Receive a video frame from some upstream source. The foreground is segmented and then masked on top
    /// of the background replacement image.
    ///
    /// - Parameters:
    ///   - frame: New video frame to consume.
    public func onVideoFrameReceived(frame: VideoFrame) {
        var processedFrame: VideoFrame = frame

        // Update sinks at the end.
        defer {
            updateSinks(frame: processedFrame)
        }

        // Create `VideoFramePixelBuffer` of the input frame.
        guard let pixelBuffer = frame.buffer as? VideoFramePixelBuffer else {
            logger.debug(debugFunction: {
                return "VideoFramePixelBuffer was not found."
            })
            return
        }

        // CIImage of the input pixel buffer.
        let inputFrame = CIImage(cvImageBuffer: pixelBuffer.pixelBuffer)

        guard let inputCgFrame = context.createCGImage(inputFrame, from: inputFrame.extent) else {
            logger.error(msg: "Error creating CGImage of input frame.")
            return
        }

        // Retrieve the foreground alpha mask of the frame.
        guard let foregroundMask = backgroundFilterProcessor.createForegroundAlphaMask(inputFrameCG: inputCgFrame,
                                                                                       inputFrameCI: inputFrame)
        else {
            return
        }

        guard let backgroundImage = backgroundReplacementImage else {
            logger.error(msg: "Error retrieving the background replacement image.")
            return
        }
        // Create the final output image by blending the alpha mask on top of the input frame to produce
        // the foreground image which is placed on top of the background replacement image.
        guard let outputImage: CIImage = backgroundFilterProcessor.blendWithWithAlphaMask(inputFrameCI: inputFrame,
                                                                                          maskImage: foregroundMask,
                                                                                          backgroundImage: backgroundImage)
        else {
            logger.error(msg: "Error producing the final output image.")
            return
        }

        // Create the final `CVPixelBuffer` for the output image.
        var mergedImageBuffer: CVPixelBuffer?
        guard let bufferPool = backgroundFilterProcessor.getBufferPool() else {
            logger.error(msg: "Error retrieving final buffer pool.")
            return
        }
        CVPixelBufferPoolCreatePixelBuffer(nil, bufferPool, &mergedImageBuffer)
        guard let validMergedImageBuffer = mergedImageBuffer else {
            logger.error(msg: "Error creating CVPixelBuffer for output image.")
            return
        }

        // Render the output CGImage image in the buffer.
        context.render(outputImage, to: validMergedImageBuffer)

        processedFrame = VideoFrame(timestampNs: frame.timestampNs,
                                    rotation: frame.rotation,
                                    buffer: VideoFramePixelBuffer(pixelBuffer: validMergedImageBuffer))
    }

    /// Allow builders to change background image after initialization.
    ///
    /// - Parameters:
    ///   - newBackgroundReplacementImage: New background replacement image.
    public func setBackgroundImage(newBackgroundReplacementImage: UIImage) {
        guard let backgroundImage = newBackgroundReplacementImage.cgImage else {
            logger.error(msg: "Error trying to change background replacement image.")
            return
        }
        backgroundReplacementImage = CIImage(cgImage: backgroundImage)
    }

    /// Adds a video sink to the sinks set.
    public func addVideoSink(sink: VideoSink) {
        sinks.add(sink)
    }

    /// Remove a video sink from the sinks set.
    public func removeVideoSink(sink: VideoSink) {
        sinks.remove(sink)
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
