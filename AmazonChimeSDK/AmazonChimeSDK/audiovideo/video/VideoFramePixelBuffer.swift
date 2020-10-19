//
//  VideoFramePixelBuffer.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import CoreVideo
import Foundation

/// `VideoFramePixelBuffer` is a buffer which contains a single video frame in the form of `CVPixelBuffer`.
@objcMembers public class VideoFramePixelBuffer: NSObject, VideoFrameBuffer {
    public func width() -> Int {
        return CVPixelBufferGetWidth(pixelBuffer)
    }

    public func height() -> Int {
        return CVPixelBufferGetHeight(pixelBuffer)
    }

    // Underlying pixel buffer holding video frame
    public let pixelBuffer: CVPixelBuffer

    public init(pixelBuffer: CVPixelBuffer) {
        self.pixelBuffer = pixelBuffer
    }
}
