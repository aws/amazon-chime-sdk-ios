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

    /// Final blur image checksum for types of blur respectively.
    let expectedBlurHashes = ["93c1c6b8187eac9c63241d42329f6b0e8596cc6dff3f81df06bf699da711d31e",
                              "da145872323b9f7d4678b5cf6db7d9fd510efe6f01f353a11d2b62e44b1646db",
                              "28f978e8ca2cbb1abc770ceaa247d42dd234c5c280e8ccaa4453a980bbb4bfa7"]

    /// Final replacement image checksum using two different color generated backgrounds.
    let expectedReplacementHashes = ["52f2bc2ae95a23990ffb9bf2393d3836802f26f749a4cdbebc2f63077192eec7",
                                     "bc0797551caeda93c6fd90a26f4d1746027b9b3724cb868b09608e34964e2aa6"]

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
        self.testImage = testImage
    }

    /// Test `BackgroundBlurVideoFrameProcessor` functionalities  on the testImage frame.
    func testBackgroundBlurVideoFrameProcessor() {
        #if canImport(AmazonChimeSDKMachineLearning)
        guard let frame = generateVideoFrame() else {
            return
        }

        let videoSinkMock = mock(VideoSink.self)
        var hash = ""
        var videoFrameReceivedExpectation: XCTestExpectation? = nil

        given(videoSinkMock.onVideoFrameReceived(frame: any())) ~> { [self] videoFrame in
            hash = self.generateHash(frame: videoFrame)
            videoFrameReceivedExpectation!.fulfill()
        }

        let backgroundBlurConfigurations = BackgroundBlurConfiguration(logger: ConsoleLogger(name: "BackgroundBlurProcessor"))
        let processor = BackgroundBlurVideoFrameProcessor(backgroundBlurConfiguration: backgroundBlurConfigurations)

        processor.addVideoSink(sink: videoSinkMock)

        // Verify the checksum for the different blur strengths.
        let blurList = [BackgroundBlurStrength.low, BackgroundBlurStrength.medium, BackgroundBlurStrength.high]
        for index in 0...(blurList.count - 1) {
            videoFrameReceivedExpectation = expectation(description: "Video frame is received for index \(index)")

            processor.setBlurStrength(newBlurStrength: blurList[index])
            processor.onVideoFrameReceived(frame: frame)

            // Wait for the image to generate before proceeding to avoid non-determinism.
            waitForExpectations(timeout: 1) { error in
                if let error = error {
                    XCTFail("waitForExpectationsWithTimeout errored for index \(index): \(error)")
                }
            }
            XCTAssertEqual(expectedBlurHashes[index], hash, "Failed with \(hash) received hash.")
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
        var hash = ""
        var videoFrameReceivedExpectation: XCTestExpectation? = nil

        given(videoSinkMock.onVideoFrameReceived(frame: any())) ~> { videoFrame in
            hash = self.generateHash(frame: videoFrame)
            videoFrameReceivedExpectation!.fulfill()
        }

        let replacementImageColors = [UIColor.blue, UIColor.red]
        var backgroundReplacementImage = generateBackgroundImage(width: frame.width,
                                                                 height: frame.height,
                                                                 color: replacementImageColors[0])
        let logger = ConsoleLogger(name: "testBackgroundBlurVideoFrameProcessor")
        let backgroundReplacementConfigurations = BackgroundReplacementConfiguration(logger: logger,
                                                                                     backgroundReplacementImage: backgroundReplacementImage)

        let processor = BackgroundReplacementVideoFrameProcessor(backgroundReplacementConfiguration: backgroundReplacementConfigurations)

        processor.addVideoSink(sink: videoSinkMock)

        // Loop through the different generated backgrounds images and verify checksum.
        for index in 0...replacementImageColors.count - 1 {
            videoFrameReceivedExpectation = expectation(description: "Video frame is received for index \(index)")

            if index > 0 {
                backgroundReplacementImage = generateBackgroundImage(width: frame.width,
                                                                     height: frame.height,
                                                                     color: replacementImageColors[index])
                processor.setBackgroundImage(newBackgroundReplacementImage: backgroundReplacementImage)
            }
            processor.onVideoFrameReceived(frame: frame)

            // Wait for the image to generate before proceeding to avoid non-determinism.
            waitForExpectations(timeout: 1) { error in
                if let error = error {
                    XCTFail("waitForExpectationsWithTimeout errored for index \(index): \(error)")
                }
            }

            // Verify checksum is as expected.
            XCTAssertEqual(expectedReplacementHashes[index], hash, "Failed with \(hash) received hash.")
        }
        #else
        XCTFail("AmazonChimeSDKMachineLearning could not be imported.")
        #endif
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
        guard let testImageCg = uiImage.cgImage else {
            return nil
        }
        let height = testImageCg.height
        let width = testImageCg.width

        var cVPPixelBuffer: CVPixelBuffer?
        CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, nil, &cVPPixelBuffer)
        context.render(CIImage(cgImage: testImageCg), to: cVPPixelBuffer!)

        let buffer = VideoFramePixelBuffer(pixelBuffer: cVPPixelBuffer!)
        let frame = VideoFrame(timestampNs: 0, rotation: .rotation0, buffer: buffer)
        return frame
    }

    /// Generate the check sum of a video frame. This function should only be used in the context
    /// of a test as the generated image will be attached for reference.
    ///
    /// - Parameters:
    ///   - frame: `background-ml-test-image.jpg` video frame.
    func generateHash(frame: VideoFrame) -> String {
        guard let pixelBuffer = frame.buffer as? VideoFramePixelBuffer else {
            return ""
        }
        CVPixelBufferLockBaseAddress(pixelBuffer.pixelBuffer, CVPixelBufferLockFlags.readOnly)
        guard let address = CVPixelBufferGetBaseAddress(pixelBuffer.pixelBuffer) else {
            XCTFail("Failed to retrieve frame buffer address.")
            return ""
        }
        let contextDataPointer: UnsafeMutablePointer<UInt8> = address.bindMemory(to: UInt8.self,
                                                                                 capacity: frame.width * frame.height * 4)
        let imageCfData = CFDataCreate(nil, contextDataPointer, frame.width * frame.height * 4)
        let cgProvider = CGDataProvider.init(data: imageCfData!)!
        var hashArray = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        let nsImageData = NSData(data: (cgProvider.data as Data?)!)

        // Attach images for manual testing and debugging purposes.
        // In the test view, right click the test and use the "Jump to Report"
        // to see the attached images.
        let ciImage = CIImage(cvImageBuffer: pixelBuffer.pixelBuffer)
        let context = CIContext(options: [.cacheIntermediates: false])
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            XCTFail("Error creating CGImage of input frame.")
            return ""
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

        return hexString
    }
}
