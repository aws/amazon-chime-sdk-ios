//
//  BackgroundFilterCIImageTest.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
#if canImport(AmazonChimeSDKMachineLearning)
@testable import AmazonChimeSDKMachineLearning
#endif
import XCTest

extension BackgroundFilterTests {
    /// Verify lazy model-resolution mask scaling preserves the public mask path's output.
    func testModelResolutionForegroundMaskMatchesPublicPath() {
        #if canImport(AmazonChimeSDKMachineLearning)
        guard let inputCGImage = testImage?.cgImage else {
            XCTFail("Failed to load test image as CGImage.")
            return
        }
        let inputCIImage = CIImage(cgImage: inputCGImage)
        let publicProcessor = BackgroundFilterProcessor(logger: loggerMock)
        let lazyProcessor = BackgroundFilterProcessor(logger: loggerMock)

        guard let publicMask = publicProcessor.createForegroundAlphaMask(
            inputFrameCG: inputCGImage,
            inputFrameCI: inputCIImage
        ), let lazyMask = lazyProcessor.createForegroundAlphaMaskWithLazyUpscale(
            inputFrameCI: inputCIImage
        ) else {
            XCTFail("Failed to create foreground masks.")
            return
        }

        let context = CIContext(options: [.cacheIntermediates: false])
        guard let publicCGImage = context.createCGImage(publicMask, from: publicMask.extent),
              let lazyCGImage = context.createCGImage(lazyMask, from: lazyMask.extent),
              let publicData = publicCGImage.dataProvider?.data,
              let lazyData = lazyCGImage.dataProvider?.data,
              let publicBytes = CFDataGetBytePtr(publicData),
              let lazyBytes = CFDataGetBytePtr(lazyData) else {
            XCTFail("Failed to access foreground mask data.")
            return
        }

        let requiredDataLength = lazyCGImage.bytesPerRow * lazyCGImage.height
        guard publicCGImage.width == lazyCGImage.width && publicCGImage.height == lazyCGImage.height,
              publicCGImage.bitsPerPixel == lazyCGImage.bitsPerPixel,
              publicCGImage.bitsPerComponent == 8,
              publicCGImage.bitsPerComponent == lazyCGImage.bitsPerComponent,
              publicCGImage.bitsPerPixel >= 24,
              publicCGImage.bytesPerRow == lazyCGImage.bytesPerRow,
              publicCGImage.bytesPerRow >= publicCGImage.width * 3,
              CFDataGetLength(publicData) >= requiredDataLength,
              CFDataGetLength(lazyData) >= requiredDataLength else {
            XCTFail("Foreground mask layouts are incompatible.")
            return
        }

        let matchPercentage = getCGImageMatchPercentage(
            expectedCgImage: publicCGImage,
            gotCgImage: lazyCGImage,
            expectedCgImageBytes: publicBytes,
            gotCgImageBytes: lazyBytes
        )
        XCTAssertGreaterThanOrEqual(matchPercentage, expectedMatchPercentage)
        #else
        XCTFail("AmazonChimeSDKMachineLearning could not be imported.")
        #endif
    }

    /// Verify the lazy model-resolution mask upscale preserves the input frame's extent and origin.
    func testModelResolutionForegroundMaskPreservesTranslatedInputExtent() {
        #if canImport(AmazonChimeSDKMachineLearning)
        guard let inputCGImage = testImage?.cgImage else {
            XCTFail("Failed to load test image as CGImage.")
            return
        }

        let translatedInput = CIImage(cgImage: inputCGImage).transformed(
            by: CGAffineTransform(translationX: 19, y: 31)
        )
        let processor = BackgroundFilterProcessor(logger: loggerMock)

        guard let foregroundMask = processor.createForegroundAlphaMaskWithLazyUpscale(
            inputFrameCI: translatedInput
        ) else {
            XCTFail("Failed to create foreground mask.")
            return
        }

        XCTAssertEqual(foregroundMask.extent, translatedInput.extent)
        #else
        XCTFail("AmazonChimeSDKMachineLearning could not be imported.")
        #endif
    }

    /// Verify segmentation materializes only the model-sized CPU-readable input.
    func testModelInputImageUsesSegmentationResolution() {
        guard let inputCGImage = testImage?.cgImage else {
            XCTFail("Failed to load test image as CGImage.")
            return
        }

        let translatedInput = CIImage(cgImage: inputCGImage).transformed(
            by: CGAffineTransform(translationX: 19, y: 31)
        )
        let processor = BackgroundFilterProcessor(logger: loggerMock)

        guard let modelInput = processor.createModelInputImage(inputFrameCI: translatedInput) else {
            XCTFail("Failed to create model input image.")
            return
        }

        XCTAssertEqual(modelInput.width, 144)
        XCTAssertEqual(modelInput.height, 256)
    }

    /// Verify an invalid image extent cannot produce a segmentation input.
    func testModelInputImageRejectsInvalidExtent() {
        let processor = BackgroundFilterProcessor(logger: loggerMock)
        let infiniteInput = CIImage(color: CIColor(red: 1, green: 1, blue: 1))

        XCTAssertNil(processor.createModelInputImage(inputFrameCI: CIImage.empty()))
        XCTAssertNil(processor.createModelInputImage(inputFrameCI: infiniteInput))
    }

    /// Verify reduced-resolution blur restores the original full-resolution extent.
    func testReducedResolutionBlurPreservesInputExtent() {
        guard let inputCGImage = testImage?.cgImage else {
            XCTFail("Failed to load test image as CGImage.")
            return
        }

        let inputCIImage = CIImage(cgImage: inputCGImage)
        let configuration = BackgroundBlurConfiguration(logger: loggerMock)
        let processor = BackgroundBlurVideoFrameProcessor(backgroundBlurConfiguration: configuration)
        let blurredImage = processor.createBackgroundBlurredImage(inputFrame: inputCIImage)

        XCTAssertEqual(blurredImage.extent, inputCIImage.extent)
    }
}
