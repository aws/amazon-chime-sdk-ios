//
//  VideoFrameTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class VideoFrameTests: XCTestCase {
    func testInitShoudPopulateProperties() {
        var cVPPixelBuffer: CVPixelBuffer?
        CVPixelBufferCreate(kCFAllocatorDefault, 3840, 2160, kCVPixelFormatType_32ARGB, nil, &cVPPixelBuffer)
        let buffer = VideoFramePixelBuffer(pixelBuffer: cVPPixelBuffer!)
        let frame = VideoFrame(timestampNs: Int64.max, rotation: .rotation0, buffer: buffer)

        XCTAssertEqual(frame.width, 3840)
        XCTAssertEqual(frame.height, 2160)
        XCTAssertEqual(frame.rotation, .rotation0)
        XCTAssertEqual(frame.timestampNs, 9223372036854775807)
    }
}
