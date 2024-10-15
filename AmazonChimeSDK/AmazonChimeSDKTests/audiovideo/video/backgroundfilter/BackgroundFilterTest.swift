//
//  BackgroundFilterTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
#if canImport(AmazonChimeSDKMachineLearning)
@testable import AmazonChimeSDKMachineLearning
#endif
import Mockingbird
import XCTest
import CommonCrypto

/// XCTest file to test `BackgroundBlurVideoFrameProcessor` and `BackgroundReplacementVideoFrameProcessor`.
class BackgroundFilterTests: XCTestCase {
    var loggerMock: LoggerMock!
    var testImage: UIImage?
    var expectedBlurImage: UIImage?
    var expectedReplacementImage: UIImage?

    /// Expected similarity match for images.
    let expectedMatchPercentage = 0.95

    /// Maximum pixel difference allowed when comparing similarity.
    let expectedPixelMatchThreshold = Int(255 * 0.05)

    /// Downscaled size used for testing. Note that we prefer downscaling
    /// because it's more efficient for the test. Otherwise, we end up doing
    /// a lot more comparisons and the test takes longer.
    let downscaledSize = CGSize(width: 144, height: 256)

    let context = CIContext(options: [.cacheIntermediates: false])

    override func setUp() {
        loggerMock = mock(Logger.self)
        /// Load test image that will be used by the tests.
        guard let testImage = UIImage(named: "background-ml-test-image.jpeg",
                                      in: Bundle(for: type(of: self)),
                                      compatibleWith: nil) else {
            XCTFail("Failed to load test image.")
            return
        }
        guard let expectedBlurImage = UIImage(named: "expected-blur-test-image.png",
                                              in: Bundle(for: type(of: self)),
                                              compatibleWith: nil) else {
            XCTFail("Failed to load expected blur image.")
            return
        }
        guard let expectedReplacementImage = UIImage(named: "expected-replacement-test-image.png",
                                                     in: Bundle(for: type(of: self)),
                                                     compatibleWith: nil) else {
            XCTFail("Failed to load expected replacement image.")
            return
        }

        self.testImage = testImage
        self.expectedBlurImage = expectedBlurImage
        self.expectedReplacementImage = expectedReplacementImage
    }

    /// Test `BackgroundBlurVideoFrameProcessor` functionalities  on the testImage frame.
    func testBackgroundBlurVideoFrameProcessor() {
        #if canImport(AmazonChimeSDKMachineLearning)
        guard let frame = generateVideoFrame() else {
            return
        }

        let videoSinkMock = mock(VideoSink.self)
        var processedImage: UIImage?
        var videoFrameReceivedExpectation: XCTestExpectation?

        given(videoSinkMock.onVideoFrameReceived(frame: any())) ~> { [self] videoFrame in
            let result = self.processImage(frame: videoFrame)
            processedImage = result.image
            videoFrameReceivedExpectation!.fulfill()
        }

        let backgroundBlurConfigurations = BackgroundBlurConfiguration(
            logger: ConsoleLogger(name: "testBackgroundBlurVideoFrameProcessor"))
        let processor = BackgroundBlurVideoFrameProcessor(backgroundBlurConfiguration: backgroundBlurConfigurations)

        processor.addVideoSink(sink: videoSinkMock)

        // Verify the checksum for the different blur strengths.
        let blurList = [BackgroundBlurStrength.high]
        for index in 0...(blurList.count - 1) {
            processedImage = nil
            videoFrameReceivedExpectation = expectation(description: "Video frame is received for index \(index)")

            processor.setBlurStrength(newBlurStrength: blurList[index])
            processor.onVideoFrameReceived(frame: frame)

            // Wait for the image to generate before proceeding to avoid non-determinism.
            wait(for: [videoFrameReceivedExpectation!], timeout: 1)
            XCTAssert(processedImage != nil)

            guard let gotCgImage = self.resize(image: processedImage!, to: downscaledSize).cgImage,
                let gotCgImageData = gotCgImage.dataProvider?.data,
                let gotCgImageBytes = CFDataGetBytePtr(gotCgImageData) else {
                XCTFail("Couldn't access CGImage data")
                return
            }
            guard let expectedCgImage = self.resize(image: self.expectedBlurImage!, to: downscaledSize).cgImage,
                let expectedCgImageData = expectedCgImage.dataProvider?.data,
                let expectedCgImageBytes = CFDataGetBytePtr(expectedCgImageData) else {
                XCTFail("Couldn't access CGImage data")
                return
            }
            XCTAssert(gotCgImage.colorSpace?.model == .rgb)
            XCTAssert(expectedCgImage.colorSpace?.model == .rgb)
            XCTAssertEqual(expectedCgImage.bitsPerPixel, gotCgImage.bitsPerPixel)
            XCTAssertEqual(expectedCgImage.bitsPerComponent, gotCgImage.bitsPerComponent)
            XCTAssertEqual(expectedCgImage.height, gotCgImage.height)
            XCTAssertEqual(expectedCgImage.width, gotCgImage.width)

            let matchPercentage = self.getCGImageMatchPercentage(
                expectedCgImage: expectedCgImage, gotCgImage: gotCgImage,
                expectedCgImageBytes: expectedCgImageBytes, gotCgImageBytes: gotCgImageBytes)
            XCTAssert(matchPercentage >= expectedMatchPercentage,
                      "Expected match percentage \(matchPercentage) to be >= \(expectedMatchPercentage)")
        }
        #else
        XCTFail("AmazonChimeSDKMachineLearning could not be imported.")
        #endif
    }

    /// Test `BackgroundReplacementVideoFrameProcessor` functionalities on the testImage frame.
    func testBackgroundReplacementVideoFrameProcessor() {
        #if canImport(AmazonChimeSDKMachineLearning)
        guard let frame = generateVideoFrame() else {
            return
        }

        let videoSinkMock = mock(VideoSink.self)
        var processedImage: UIImage?
        var videoFrameReceivedExpectation: XCTestExpectation?

        given(videoSinkMock.onVideoFrameReceived(frame: any())) ~> { videoFrame in
            let result = self.processImage(frame: videoFrame)
            processedImage = result.image
            videoFrameReceivedExpectation!.fulfill()
        }

        let replacementImageColors = [UIColor.red]
        var backgroundReplacementImage = generateBackgroundImage(width: frame.width,
                                                                 height: frame.height,
                                                                 color: replacementImageColors[0])
        let logger = ConsoleLogger(name: "testBackgroundReplacementVideoFrameProcessor")
        let backgroundReplacementConfigurations = BackgroundReplacementConfiguration(
            logger: logger,
            backgroundReplacementImage: backgroundReplacementImage
        )

        let processor = BackgroundReplacementVideoFrameProcessor(
            backgroundReplacementConfiguration: backgroundReplacementConfigurations)

        processor.addVideoSink(sink: videoSinkMock)

        // Loop through the different generated backgrounds images and verify checksum.
        for index in 0...replacementImageColors.count - 1 {
            processedImage = nil
            videoFrameReceivedExpectation = expectation(description: "Video frame is received for index \(index)")

            if index > 0 {
                backgroundReplacementImage = generateBackgroundImage(width: frame.width,
                                                                     height: frame.height,
                                                                     color: replacementImageColors[index])
                processor.setBackgroundImage(newBackgroundReplacementImage: backgroundReplacementImage)
            }
            processor.onVideoFrameReceived(frame: frame)

            // Wait for the image to generate before proceeding to avoid non-determinism.
            wait(for: [videoFrameReceivedExpectation!], timeout: 1)
            XCTAssert(processedImage != nil)

            guard let gotCgImage = self.resize(image: processedImage!, to: downscaledSize).cgImage,
                let gotCgImageData = gotCgImage.dataProvider?.data,
                let gotCgImageBytes = CFDataGetBytePtr(gotCgImageData) else {
                XCTFail("Couldn't access CGImage data")
                return
            }
            guard let expectedCgImage = self.resize(image: self.expectedReplacementImage!, to: downscaledSize).cgImage,
                let expectedCgImageData = expectedCgImage.dataProvider?.data,
                let expectedCgImageBytes = CFDataGetBytePtr(expectedCgImageData) else {
                XCTFail("Couldn't access CGImage data")
                return
            }
            XCTAssert(gotCgImage.colorSpace?.model == .rgb)
            XCTAssert(expectedCgImage.colorSpace?.model == .rgb)
            XCTAssertEqual(expectedCgImage.bitsPerPixel, gotCgImage.bitsPerPixel)
            XCTAssertEqual(expectedCgImage.bitsPerComponent, gotCgImage.bitsPerComponent)
            XCTAssertEqual(expectedCgImage.height, gotCgImage.height)
            XCTAssertEqual(expectedCgImage.width, gotCgImage.width)

            let matchPercentage = self.getCGImageMatchPercentage(
                expectedCgImage: expectedCgImage, gotCgImage: gotCgImage,
                expectedCgImageBytes: expectedCgImageBytes, gotCgImageBytes: gotCgImageBytes)
            XCTAssert(matchPercentage >= expectedMatchPercentage,
                      "Expected match percentage \(matchPercentage) to be >= \(expectedMatchPercentage)")
        }
        #else
        XCTFail("AmazonChimeSDKMachineLearning could not be imported.")
        #endif
    }

    /// Test `NoopSegmentationProcessor` for coverage purposes.
    func testNoopSegmentationProcessor() {
        let segmentationProcessor = NoopSegmentationProcessor()
        let initializeResult = segmentationProcessor.initialize(144, width: 256, channels: 4)
        XCTAssertTrue(initializeResult)

        let predictResult = segmentationProcessor.predict()
        XCTAssertTrue(predictResult)

        let modelStateResult = segmentationProcessor.getModelState()
        XCTAssertEqual(CwtModelState.LOADED.rawValue, UInt(modelStateResult))

        let inputBuffer = segmentationProcessor.getInputBuffer()
        XCTAssertNotNil(inputBuffer)

        let outputBuffer = segmentationProcessor.getOutputBuffer()
        XCTAssertNotNil(outputBuffer)
    }

    /// Generates a blue background image used as a background replacement image
    /// for `BackgroundReplacementVideoFrameProcessor` test.
    ///
    /// - Parameters:
    ///   - width: width of the replacement image.
    ///   - height: height of the replacement image.
    ///   - color;  Background UIColor.
    func generateBackgroundImage(width: Int, height: Int, color: UIColor) -> UIImage {
        let rect = CGRect(x: 0,
                          y: 0,
                          width: width,
                          height: height)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width,
                                                      height: height),
                                               false, 0)
        color.setFill()
        UIRectFill(rect)
        let backgroundReplacementImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return backgroundReplacementImage
    }

    /// Generates a `VideoFrame` for the test image.
    func generateVideoFrame() -> VideoFrame? {
        guard let uiImage = testImage else {
            return nil
        }
        guard let testCGImage = uiImage.cgImage else {
            return nil
        }
        let height = testCGImage.height
        let width = testCGImage.width

        var cvPixelBuffer: CVPixelBuffer?
        CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, nil, &cvPixelBuffer)
        context.render(CIImage(cgImage: testCGImage), to: cvPixelBuffer!)

        let buffer = VideoFramePixelBuffer(pixelBuffer: cvPixelBuffer!)
        let frame = VideoFrame(timestampNs: 0, rotation: .rotation0, buffer: buffer)
        return frame
    }

    /// Generate the check sum of a video frame and return processed UIImage. This function should only be used in the
    /// context of a test as the generated image will be attached for reference.
    ///
    /// - Parameters:
    ///   - frame: `background-ml-test-image.jpg` video frame.
    func processImage(frame: VideoFrame) -> (hash: String, image: UIImage?) {
        guard let pixelBuffer = frame.buffer as? VideoFramePixelBuffer else {
            return ("", nil)
        }
        CVPixelBufferLockBaseAddress(pixelBuffer.pixelBuffer, CVPixelBufferLockFlags.readOnly)
        guard let address = CVPixelBufferGetBaseAddress(pixelBuffer.pixelBuffer) else {
            XCTFail("Failed to retrieve frame buffer address.")
            return ("", nil)
        }
        let contextDataPointer: UnsafeMutablePointer<UInt8> = address.bindMemory(
            to: UInt8.self,
            capacity: frame.width * frame.height * 4)

        let imageCfData = CFDataCreate(nil, contextDataPointer, frame.width * frame.height * 4)
        let cgProvider = CGDataProvider.init(data: imageCfData!)!
        var hashArray = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        let nsImageData = NSData(data: (cgProvider.data as Data?)!)

        // Attach images for manual testing and debugging purposes.
        // In the test view, right click the test and use "Jump to Report"
        // to see the attached images.
        let ciImage = CIImage(cvImageBuffer: pixelBuffer.pixelBuffer)
        let context = CIContext(options: [.cacheIntermediates: false])
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            XCTFail("Error creating CGImage of input frame.")
            return ("", nil)
        }
        let image = UIImage(cgImage: cgImage)
        let attachment = XCTAttachment(image: image)
        attachment.lifetime = .keepAlways
        self.add(attachment)

        CC_SHA256(nsImageData.bytes, UInt32(nsImageData.count), &hashArray)

        let finalData = NSData(bytes: hashArray, length: Int(CC_SHA256_DIGEST_LENGTH))

        var bytes = [UInt8](repeating: 0, count: finalData.length)
        finalData.getBytes(&bytes, length: finalData.length)

        var hexString = ""
        for byte in bytes {
            hexString += String(format: "%02x", UInt8(byte))
        }

        CVPixelBufferUnlockBaseAddress(pixelBuffer.pixelBuffer, CVPixelBufferLockFlags.readOnly)

        return (hexString, image)
    }

    /// Returns the match percentage associated with two CGImages and their byte pointers.
    ///
    /// - Parameters:
    ///   - expectedCgImage: First image to compare against..
    ///   - gotCgImage: Second CGImage to compare against.
    ///   - expectedCgImageBytes: First CGImage byte pointer to compare against.
    ///   - gotCgImageBytes: Second CGImage byte pointer to compare against
    func getCGImageMatchPercentage(
        expectedCgImage: CGImage, gotCgImage: CGImage,
        expectedCgImageBytes: UnsafePointer<UInt8>, gotCgImageBytes: UnsafePointer<UInt8>
    ) -> Double {
        var matchCount = 0
        let totalPixels = gotCgImage.height * gotCgImage.width
        let bytesPerPixel = gotCgImage.bitsPerPixel / gotCgImage.bitsPerComponent
        for row in 0 ..< gotCgImage.height {
            for col in 0 ..< gotCgImage.width {
                let offset = (row * gotCgImage.bytesPerRow) + (col * bytesPerPixel)
                let match = self.getRGBMatch(offset: offset,
                                             expectedImageBytes: expectedCgImageBytes, gotImageBytes: gotCgImageBytes)
                if match {
                    matchCount += 1
                }
            }
        }
        let matchPercentage = Double(matchCount) / Double(totalPixels)
        return matchPercentage
    }

    /// Returns whether the RGB pixel value at a given offset matches for two CGImages.
    ///
    /// - Parameters:
    ///   - offset: Index in the expectedImageBytes and gotImageBytes.
    ///   - expectedImageBytes: First CGImage byte pointer to compare against.
    ///   - gotImageBytes: Second CGImage byte pointer to compare against.
    func getRGBMatch(
        offset: Int,
        expectedImageBytes: UnsafePointer<UInt8>,
        gotImageBytes: UnsafePointer<UInt8>
    ) -> Bool {
        let rDiff = Int32(expectedImageBytes[offset]) - Int32(gotImageBytes[offset])
        let gDiff = Int32(expectedImageBytes[offset+1]) - Int32(gotImageBytes[offset+1])
        let bDiff = Int32(expectedImageBytes[offset+2]) - Int32(gotImageBytes[offset+2])
        let rMatch = abs(rDiff) < expectedPixelMatchThreshold
        let gMatch = abs(gDiff) < expectedPixelMatchThreshold
        let bMatch = abs(bDiff) < expectedPixelMatchThreshold
        return rMatch && gMatch && bMatch
    }

    /// Resize and rescale images. This is particularly useful for upsampling and downsampling.
    ///
    /// - Parameters:
    ///   - image: Input image  to resize..
    ///   - to: New size of the input image..
    func resize(image: UIImage, to newSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: newSize).image { _ in
            let hScale = newSize.height / image.size.height
            let vScale = newSize.width / image.size.width
            let scale = max(hScale, vScale)
            let resizeSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
            var middle = CGPoint.zero
            if resizeSize.width > newSize.width {
                middle.x -= (resizeSize.width - newSize.width) / 2.0
            }
            if resizeSize.height > newSize.height {
                middle.y -= (resizeSize.height - newSize.height) / 2.0
            }
            image.draw(in: CGRect(origin: middle, size: resizeSize))
        }
    }
}
