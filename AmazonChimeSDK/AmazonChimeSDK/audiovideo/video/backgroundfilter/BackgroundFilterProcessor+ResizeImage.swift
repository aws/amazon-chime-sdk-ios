//
//  BackgroundFilterProcessor+ResizeImage.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import CoreGraphics
import CoreImage
import Foundation

extension BackgroundFilterProcessor {
    /// Resize CGImage to the given size.
    ///
    /// - Parameters:
    ///   - image: Input image to resize.
    ///   - newSize: Size of the image output.
    ///
    /// - Returns: Resized image.
    func resizeImage(image: CGImage, newSize: CGSize) -> CGImage? {
        guard let colorSpace = image.colorSpace else {
            logger.error(msg: "Unable to find color space")
            return nil
        }

        let width = Int(newSize.width)
        let height = Int(newSize.height)
        let bitsPerComponent = image.bitsPerComponent
        let bitsPerPixel = image.bitsPerPixel

        var bitmapInfo = image.bitmapInfo
        var alphaInfo = bitmapInfo.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        if alphaInfo == CGImageAlphaInfo.last.rawValue {
            alphaInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        } else if alphaInfo == CGImageAlphaInfo.first.rawValue {
            alphaInfo = CGImageAlphaInfo.premultipliedFirst.rawValue
        }
        bitmapInfo = CGBitmapInfo(
            rawValue: bitmapInfo.rawValue & ~CGBitmapInfo.alphaInfoMask.rawValue | alphaInfo
        )

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

        guard let outputImage = blendFilter.outputImage else {
            logger.error(msg: "Error creating the blended output image.")
            return nil
        }

        return outputImage
    }

    /// Materializes only the model-resolution input rather than a CPU-readable full-resolution frame.
    func createModelInputImage(inputFrameCI: CIImage) -> CGImage? {
        let inputExtent = inputFrameCI.extent
        guard inputExtent.width > 0, inputExtent.height > 0 else {
            logger.error(msg: "Unable to create segmentation input from an empty extent")
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
}
