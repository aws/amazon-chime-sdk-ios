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
    private let context = CIContext(options: [.cacheIntermediates: false])

    /// `CVPixelBufferPool` used to store the final output image.
    private var bufferPool: CVPixelBufferPool?

    /// Used to track buffer pool width.
    private var bufferPoolWidth: Int = 0

    /// Used to track buffer pool height.
    private var bufferPoolHeight: Int = 0

    /// Used to track the segmentation processor's initialized channel count.
    private var segmentationProcessorChannels: Int = 0

    /// A segmentation processor used to predict foreground of an image.
    /// See `SegmentationProcessor` for more details.
    private let segmentationProcessor: SegmentationProcessor

    /// Custom logger to log any errors or warnings.
    let logger: Logger

    /// Segmentation processor height.
    private var segmentationProcessorHeight = 256

    /// Segmentation processor width.
    private var segmentationProcessorWidth = 144

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

    /// Blends foreground alpha mask with input image to produce a foreground image which is rendered on top
    /// of a background image using `CIBlendWithAlphaMask` CIFilter.
    ///
    /// - Parameters:
    ///   - inputFrameCI: Input image which is used to blend the foreground alpha mask to produce the foreground image.
    ///   - maskImage: Foreground alpha mask.
    ///   - backgroundImage: Background image which can be a blurred or a custom background image.
    public func blendWithWithAlphaMask(inputFrameCI: CIImage,
                                       maskImage: CIImage,
                                       backgroundImage: CIImage) -> CIImage? {
        guard let blendFilter = CIFilter(name: "CIBlendWithAlphaMask") else {
            logger.error(msg: "Error creating CIBlendWithAlphaMask CIFilter.")
            return nil
        }

        blendFilter.setValue(backgroundImage, forKey: "inputBackgroundImage")
        blendFilter.setValue(inputFrameCI, forKey: "inputImage")
        blendFilter.setValue(maskImage, forKey: "inputMaskImage")

        // Create the output image.
        guard let outputImage = blendFilter.outputImage else {
            logger.error(msg: "Error creating the blended output image.")
            return nil
        }

        return outputImage
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

    /// Resize CGImage to the given size.
    ///
    /// - Parameters:
    ///   - image: Input image to resize.
    ///   - newSize: Size of the image output.
    ///
    /// - Returns: Resized image.
    private func resizeImage(image: CGImage, newSize: CGSize) -> CGImage? {
        guard let colorSpace = image.colorSpace else {
            logger.error(msg: "Unable to find color space")
            return nil
        }

        let width = Int(newSize.width)
        let height = Int(newSize.height)
        let bitsPerComponent = image.bitsPerComponent
        let bitsPerPixel = image.bitsPerPixel

        // Adjust bitmap info to take into account alpha info.
        var bitmapInfo = image.bitmapInfo
        var alphaInfo = bitmapInfo.rawValue & CGBitmapInfo.alphaInfoMask.rawValue

        // Since iOS 8, we cannot create contexts with unmultiplied alpha info.
        // As a result, if we see a bitmap with an alpha channel that is set to
        // the last, we assume that the alpha has already been premultiplied and
        // do nothing. If the alpha channel is set to first, we similarly still
        // assume it has already been premultiplied and do nothing. We do nothing
        // because the value should not have been there in the first place and we
        // prefer doing nothing over modifying the image erroneously.
        if alphaInfo == CGImageAlphaInfo.last.rawValue {
            alphaInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        } else if alphaInfo == CGImageAlphaInfo.first.rawValue {
            alphaInfo = CGImageAlphaInfo.premultipliedFirst.rawValue
        }

        // Set the new alpha info in case we have changed it.
        // In order to set the value, we take the existing alpha
        // info mask, which is used to extract the value, and invert
        // it instead. This allows us to instead set the bit value
        // with the `alphaInfo` bit. As an example, let's say we
        // have
        //    bitmapInfo    = 0010
        //    alphaInfoMask = 0001
        //    alphaInfo     = 0001
        // In this case, we'd like to set the bit of `0` to the
        // least significant bit. Inverting the `alphaInfoMask`
        // to 1110 keeps all the other bits the same while clearing
        // out the least significant bit for us to set it. In the case
        // that `alphaInfo` is one (as in this case), it will be set to
        // 1. If it was 0, it will also be set to 0 (i.e. no change).
        bitmapInfo = CGBitmapInfo(rawValue: bitmapInfo.rawValue & ~CGBitmapInfo.alphaInfoMask.rawValue | alphaInfo)

        guard let context = CGContext(data: nil,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: width * (bitsPerPixel / bitsPerComponent),
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo.rawValue) else {
            logger.error(msg: "Unable to create context when resizing image")
            return nil
        }
        context.interpolationQuality = .high
        let rect = CGRect(origin: CGPoint.zero, size: newSize)
        context.draw(image, in: rect)

        return context.makeImage()
    }
}

extension BackgroundFilterProcessor {
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

    /// Materializes only the model-resolution input rather than a CPU-readable full-resolution frame.
    func createModelInputImage(inputFrameCI: CIImage) -> CGImage? {
        let inputExtent = inputFrameCI.extent
        guard inputExtent.origin.x.isFinite,
              inputExtent.origin.y.isFinite,
              inputExtent.width.isFinite,
              inputExtent.height.isFinite,
              inputExtent.width > 0,
              inputExtent.height > 0 else {
            logger.error(msg: "Unable to create segmentation input from an invalid extent")
            return nil
        }

        let normalizedInput = inputFrameCI.transformed(
            by: CGAffineTransform(translationX: -inputExtent.origin.x, y: -inputExtent.origin.y)
        )
        let modelExtent = CGRect(
            x: 0,
            y: 0,
            width: segmentationProcessorWidth,
            height: segmentationProcessorHeight
        )
        let modelScale = CGAffineTransform(
            scaleX: modelExtent.width / inputExtent.width,
            y: modelExtent.height / inputExtent.height
        )
        let modelInput = normalizedInput
            .transformed(by: modelScale, highQualityDownsample: true)
            .cropped(to: modelExtent)

        guard let modelInputCG = context.createCGImage(modelInput, from: modelExtent) else {
            logger.error(msg: "Error creating model-resolution CGImage of input frame.")
            return nil
        }
        return modelInputCG
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

        let shouldUpdateBufferPool =
            bufferPool == nil ||
            originalWidth != bufferPoolWidth ||
            originalHeight != bufferPoolHeight
        if shouldUpdateBufferPool {
            logger.info(msg: "Updating buffer pool with new sizes: \(originalWidth) x \(originalHeight)")
            updateBufferPool(newWidth: originalWidth, newHeight: originalHeight)
        }

        if shouldUpdateBufferPool || imageChannels != segmentationProcessorChannels {
            let initializeResult = segmentationProcessor.initialize(
                segmentationProcessorHeight,
                width: segmentationProcessorWidth,
                channels: imageChannels
            )
            if !initializeResult {
                logger.error(msg: "Unable to initialize segmentation processor.")
                return false
            }
            segmentationProcessorChannels = imageChannels
        }

        if segmentationProcessor.getModelState() != CwtModelState.LOADED.rawValue {
            logger.error(msg: "Segmentation processor failed to start. Unable to perform segmentation.")
            return false
        }
        return true
    }
}
