//
//  BackgroundFilterProcessor.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import CoreImage
import CoreMedia
import Foundation
import UIKit

/// `BackgroundFilterProcessor` is a processor that uses `SegmentationProcessor` to process a frame by
/// creating the alpha mask of the foreground image and blending the mask with the input image which is then rendered on
/// top of a background image.
public class BackgroundFilterProcessor {
    /// Context used for processing and rendering the final output image.
    let context = CIContext(options: [.cacheIntermediates: false])

    /// `CVPixelBufferPool` used to store the final output image.
    private var bufferPool: CVPixelBufferPool?

    /// Used to track buffer pool width.
    private var bufferPoolWidth: Int = 0

    /// Used to track buffer pool height.
    private var bufferPoolHeight: Int = 0

    /// A segmentation processor used to predict foreground of an image.
    /// See `SegmentationProcessor` for more details.
    private let segmentationProcessor: SegmentationProcessor

    /// Custom logger to log any errors or warnings.
    let logger: Logger

    /// Segmentation processor height.
    var segmentationProcessorHeight = 256

    /// Segmentation processor width.
    var segmentationProcessorWidth = 144

    /// Static method to check whether BackgroundFilterProcessor can be used. This verifies that the builder
    /// has linked the necessary runtime framework (i.e. `AmazonChimeSDKMachineLearning`) to
    /// use this class.
    ///
    /// - Returns: true if the class can be used, otherwise false.
    public static func isAvailable() -> Bool {
        return TensorFlowSegmentationProcessor.isAvailable()
    }

    /// Public constructor to initialize the processor.
    ///
    /// - Parameters:
    ///   - logger: Custom logger to log events.
    public init(logger: Logger) {
        self.logger = logger
        if !BackgroundFilterProcessor.isAvailable() {
            self.logger.error(msg: "Unable to load TensorFlowLiteSegmentationProcessor. " +
                              "See `Update Project File` section in README for more information " +
                              "on how to import `AmazonChimeSDKMachineLearning` framework " +
                              "and the `selfie_segmentation_landscape.tflite` as a bundle resource " +
                              "to your project.")
            segmentationProcessor = NoopSegmentationProcessor()
        } else {
            segmentationProcessor = TensorFlowSegmentationProcessor()
        }
    }

    /// Creates the alpha mask [0-255] of the foreground image using `SegmentationProcessor`.
    ///
    /// - Parameters:
    ///   - inputFrameCG: Input CGImage frame to produce the foreground image.
    ///   - inputFrameCI: Input CIImage frame to produce the foreground image.
    ///
    /// - Returns: Alpha mask CGImage of the foreground.
    public func createForegroundAlphaMask(inputFrameCG: CGImage,
                                          inputFrameCI: CIImage) -> CIImage? {
        guard let maskImage = createModelResolutionForegroundMask(inputFrameCG: inputFrameCG) else {
            return nil
        }

        let originalSize = CGSize(width: inputFrameCG.width, height: inputFrameCG.height)
        guard let upscaledMaskImage = resizeImage(image: maskImage, newSize: originalSize) else {
            logger.error(msg: "Error upscaling segmentation mask")
            return nil
        }

        return CIImage(cgImage: upscaledMaskImage)
    }

    /// Creates a model-resolution foreground mask and lazily maps it to the input extent for video effects.
    func createForegroundAlphaMaskWithLazyUpscale(inputFrameCI: CIImage) -> CIImage? {
        guard BackgroundFilterProcessor.isAvailable(),
              let modelInputImage = createModelInputImage(inputFrameCI: inputFrameCI),
              let maskImage = createModelResolutionForegroundMask(
                modelInputCG: modelInputImage,
                originalSize: inputFrameCI.extent.size
              ) else {
            return nil
        }

        let lowResolutionMask = CIImage(cgImage: maskImage)
        let maskExtent = lowResolutionMask.extent
        let originalExtent = inputFrameCI.extent
        guard maskExtent.width > 0, maskExtent.height > 0 else {
            logger.error(msg: "Unable to upscale a segmentation mask with an empty extent")
            return nil
        }

        let normalizedMask = lowResolutionMask.transformed(
            by: CGAffineTransform(translationX: -maskExtent.origin.x, y: -maskExtent.origin.y)
        )
        let upscaleTransform = CGAffineTransform(
            scaleX: originalExtent.width / maskExtent.width,
            y: originalExtent.height / maskExtent.height
        )
        let originTransform = CGAffineTransform(
            translationX: originalExtent.origin.x,
            y: originalExtent.origin.y
        )

        return normalizedMask
            .transformed(by: upscaleTransform)
            .transformed(by: originTransform)
            .cropped(to: originalExtent)
    }

    private func createModelResolutionForegroundMask(inputFrameCG: CGImage) -> CGImage? {
        guard BackgroundFilterProcessor.isAvailable() else {
            return nil
        }

        let originalSize = CGSize(width: inputFrameCG.width, height: inputFrameCG.height)
        let downSize = CGSize(width: segmentationProcessorWidth, height: segmentationProcessorHeight)
        guard let downscaledImageCG = resizeImage(image: inputFrameCG, newSize: downSize) else {
            logger.error(msg: "Error downscaling input frame")
            return nil
        }

        return createModelResolutionForegroundMask(
            modelInputCG: downscaledImageCG,
            originalSize: originalSize
        )
    }

    private func createModelResolutionForegroundMask(modelInputCG: CGImage,
                                                     originalSize: CGSize) -> CGImage? {
        let imageChannels = modelInputCG.bitsPerPixel / modelInputCG.bitsPerComponent
        guard prepareSegmentationProcessor(originalSize: originalSize, imageChannels: imageChannels) else {
            return nil
        }
        guard var byteArray = ImageConversionUtils.cgImageToByteArray(cgImage: modelInputCG) else {
            logger.error(msg: "Error converting CGImage to byte array when creating the foreground mask.")
            return nil
        }

        let inputBuffer = segmentationProcessor.getInputBuffer()
        inputBuffer.initialize(from: &byteArray, count: byteArray.count)

        guard segmentationProcessor.predict() else {
            logger.error(msg: "Error predicting the foreground mask.")
            return nil
        }

        let maskOutputBuffer = segmentationProcessor.getOutputBuffer()
        guard let maskImage = ImageConversionUtils.byteArrayToCGImage(
            raw: maskOutputBuffer,
            frameWidth: segmentationProcessorWidth,
            frameHeight: segmentationProcessorHeight,
            bytesPerPixel: imageChannels,
            bitsPerComponent: modelInputCG.bitsPerComponent
        ) else {
            logger.error(msg: "Error creating CGImage of the foreground mask.")
            return nil
        }

        return maskImage
    }

    private func prepareSegmentationProcessor(originalSize: CGSize,
                                              imageChannels: Int) -> Bool {
        let originalWidth = Int(originalSize.width)
        let originalHeight = Int(originalSize.height)

        if bufferPool == nil || originalWidth != bufferPoolWidth || originalHeight != bufferPoolHeight {
            logger.info(msg: "Updating buffer pool with new sizes: \(originalWidth) x \(originalHeight)")
            updateBufferPool(newWidth: originalWidth, newHeight: originalHeight)
            let initializeResult = segmentationProcessor.initialize(
                segmentationProcessorHeight,
                width: segmentationProcessorWidth,
                channels: imageChannels
            )
            if !initializeResult {
                logger.error(msg: "Unable to initialize segmentation processor.")
                return false
            }
        }

        if segmentationProcessor.getModelState() != CwtModelState.LOADED.rawValue {
            logger.error(msg: "Segmentation processor failed to start. Unable to perform segmentation.")
            return false
        }
        return true
    }

    /// Updates the buffer pool if the previous and new frame dimensions don't match.
    ///
    /// - Parameters:
    ///   - newWidth: New frame width.
    ///   - newHeight: New frame height.
    private func updateBufferPool(newWidth: Int, newHeight: Int) {
        var attributes: [NSString: NSObject] = [:]
        attributes[kCVPixelBufferPixelFormatTypeKey] = NSNumber(value: Int(kCVPixelFormatType_32BGRA))
        attributes[kCVPixelBufferWidthKey] = NSNumber(value: newWidth)
        attributes[kCVPixelBufferHeightKey] = NSNumber(value: newHeight)
        attributes[kCVPixelBufferIOSurfacePropertiesKey] = [AnyHashable: Any]() as NSObject
        CVPixelBufferPoolCreate(nil, nil, attributes as CFDictionary?, &bufferPool)

        bufferPoolWidth = newWidth
        bufferPoolHeight = newHeight
    }

    /// - Returns: Buffer pool used to store the final image data.
    public func getBufferPool() -> CVPixelBufferPool? {
        return bufferPool
    }
}
