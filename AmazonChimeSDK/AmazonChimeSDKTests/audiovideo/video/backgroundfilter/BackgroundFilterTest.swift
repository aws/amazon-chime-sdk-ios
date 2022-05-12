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

    /// Final blur image checksum for low, medium, high respectively.
    let expectedBlurHash = ["dc3e04027cca21e16b3cf32713e5bc32d39d148cf6988e7b1cbb0fdcff59138e",
                            "5a98f494864dec0ef4cd3f61940b2068308e4f54681a0ca71589dbebfede68bd",
                            "69c707df0dce576b6ec9424511ea0241673297454bbc088db4df73aff70f5807"]

    /// Final replacement image checksum using two different color generated backgrounds.
    let expectedReplacementHash = ["48ec08db5be9fe84dde6f8545f853c3d9cc7f1664a3337fefa0d4e101ee3db5c",
                                   "004f7fec01c742183e174bb7c404d3f50ee5940006e784b29db0cf70c73bc9f2"]

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

        given(videoSinkMock.onVideoFrameReceived(frame: any())) ~> { videoFrame in
            hash = self.generateHash(frame: videoFrame)
        }

        let backgroundBlurConfigurations = BackgroundBlurConfiguration(logger: ConsoleLogger(name: "BackgroundBlurProcessor"))
        let processor = BackgroundBlurVideoFrameProcessor(backgroundBlurConfiguration: backgroundBlurConfigurations)

        processor.addVideoSink(sink: videoSinkMock)

        // Verfiy the checksum for the three different blur strengths.
        let blurList = [BackgroundBlurStrength.low, BackgroundBlurStrength.medium, BackgroundBlurStrength.high]
        for index in 0...(blurList.count - 1) {
            processor.setBlurStrength(newBlurStrength: blurList[index])
            processor.onVideoFrameReceived(frame: frame)
            XCTAssertEqual(hash, expectedBlurHash[index])
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

        given(videoSinkMock.onVideoFrameReceived(frame: any())) ~> { videoFrame in
            hash = self.generateHash(frame: videoFrame)
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
            if index > 0 {
                backgroundReplacementImage = generateBackgroundImage(width: frame.width,
                                                                     height: frame.height,
                                                                     color: replacementImageColors[index])
                processor.setBackgroundImage(newBackgroundReplacementImage: backgroundReplacementImage)
            }
            processor.onVideoFrameReceived(frame: frame)

            // Verify checksum is as expected.
            XCTAssertEqual(hash, expectedReplacementHash[index])
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

    /// Generate the check sum of a video frame.
    ///
    /// - Parameters:
    ///   - frame: `test-image.jpg` video frame.
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
