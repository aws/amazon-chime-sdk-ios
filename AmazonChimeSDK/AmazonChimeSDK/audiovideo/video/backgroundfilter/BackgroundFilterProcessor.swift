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
        // Verify that the processor is available.
        if !BackgroundFilterProcessor.isAvailable() {
            return nil
        }

        // Number of the input image color space channels.
        let imageChannels = inputFrameCG.bitsPerPixel / inputFrameCG.bitsPerComponent

        // Update the buffer pool dimensions if the new frame does not match the previous frame dimensions.
        if bufferPool == nil || inputFrameCG.width != bufferPoolWidth || inputFrameCG.height != bufferPoolHeight {

            updateBufferPool(newWidth: inputFrameCG.width, newHeight: inputFrameCG.height)
            // Initialize the segmentationProcessor if it has not been initialized.
            let initializeResult: Bool = segmentationProcessor.initialize(height: segmentationProcessorHeight,
                                                                          width: segmentationProcessorWidth,
                                                                          channels: imageChannels)
            if !initializeResult {
                logger.error(msg: "Unable to initialize segmentation processor.")
                return nil
            }
        }

        // Check if segmentation model has loaded.
        if segmentationProcessor.getModelState() != CwtModelState.LOADED.rawValue {
            logger.error(msg: "Segmentation processor failed to start. Unable to perform segmentation.")
            return nil
        }

        // Calculate the scale and aspect ratio factor to downscale.
        let downSampleScale = Double(segmentationProcessorHeight) / Double(inputFrameCG.height)
        let downSampleAspectRatio: Double = (Double(inputFrameCG.height) / Double(inputFrameCG.width)) /
                                            (Double(segmentationProcessorHeight) / Double(segmentationProcessorWidth))

        // Down sample the image.
        guard let downSampleImage: CIImage = resizeImage(image: inputFrameCI,
                                                         scale: downSampleScale,
                                                         aspectRatio: downSampleAspectRatio)
        else {
            return nil
        }

        guard let downSampleImageCg = context.createCGImage(downSampleImage,
                                                            from: downSampleImage.extent)
        else {
            return nil
        }

        // Convert the input CGImage to a UInt8 byte array.
        guard var byteArray: [UInt8] = ImageConversionUtils.cgImageToByteArray(cgImage: downSampleImageCg) else {
            logger.error(msg: "Error converting CGImage to byte array when creating the foreground mask.")
            return nil
        }

        // Copy the input buffer to the TensorFlow buffer which will be used during predict.
        let inputBuffer: UnsafeMutablePointer<UInt8> = segmentationProcessor.getInputBuffer()
        inputBuffer.initialize(from: &byteArray, count: byteArray.count)

        // Predict the foreground mask.
        let predictResult: Bool = segmentationProcessor.predict()
        if !predictResult {
            logger.error(msg: "Error predicting the foreground mask.")
            return nil
        }

        // Retrieve the foreground mask.
        let maskOutputBuffer = segmentationProcessor.getOutputBuffer()

        guard let maskImage: CGImage = ImageConversionUtils.byteArrayToCGImage(raw: maskOutputBuffer,
                                                                               frameWidth: segmentationProcessorWidth,
                                                                               frameHeight: segmentationProcessorHeight,
                                                                               bytesPerPixel: imageChannels,
                                                                               bitsPerComponent: inputFrameCG.bitsPerComponent)
        else {
            logger.error(msg: "Error creating CGImage of the foreground mask.")
            return nil
        }

        let maskImageCi = CIImage(cgImage: maskImage)

        // Calculate the scale and aspect ratio factor to upscale.
        let upSampleScale = Double(inputFrameCG.height) / Double(segmentationProcessorHeight)
        let upSampleAspectRatio: Double = (Double(segmentationProcessorHeight) / Double(segmentationProcessorWidth)) /
                                          (Double(inputFrameCG.height) / Double(inputFrameCG.width))

        // Upsample image back to it size.
        guard let upSampleImage = resizeImage(image: maskImageCi,
                                              scale: upSampleScale,
                                              aspectRatio: upSampleAspectRatio)
        else {
            return nil
        }

        return upSampleImage
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
        attributes[kCVPixelBufferIOSurfacePropertiesKey] = [:] as NSObject
        CVPixelBufferPoolCreate(nil, nil, attributes as CFDictionary?, &bufferPool)

        bufferPoolWidth = newWidth
        bufferPoolHeight = newHeight
    }

    /// - Returns: Buffer pool used to store the final image data.
    public func getBufferPool() -> CVPixelBufferPool? {
        return bufferPool
    }

    /// Resize an image using `CILanczosScaleTransform` CIFilter.
    ///
    /// - Parameters:
    ///   - image: Image to scale.
    ///   - scale: Scaling factor.
    ///   - aspectRatio: Aspect ratio factor.
    func resizeImage(image: CIImage, scale: Double, aspectRatio: Double) -> CIImage? {
        guard let resizeFilter = CIFilter(name: "CILanczosScaleTransform") else {
            logger.error(msg: "Error creating CILanczosScaleTransform CIFilter.")
            return nil
        }

        resizeFilter.setValue(CGFloat.init(scale), forKey: kCIInputScaleKey)
        resizeFilter.setValue(image, forKey: kCIInputImageKey)
        resizeFilter.setValue(CGFloat.init(aspectRatio), forKey: "inputAspectRatio")

        guard let outputResizedImage = resizeFilter.outputImage
        else {
            logger.error(msg: "Error resizing image.")
            return nil
        }
        return outputResizedImage
    }
}
