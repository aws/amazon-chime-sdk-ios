//
//  VideoFrameGenerator.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import UIKit
import AmazonChimeSDK

class VideoFrameGenerator {
    
    /// Generates a `VideoFrame` for the test image.
    func generateVideoFrame(image: UIImage) -> VideoFrame? {
        guard let testCGImage = image.cgImage else {
            return nil
        }
        let height = testCGImage.height
        let width = testCGImage.width

        var cvPixelBuffer: CVPixelBuffer?
        CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, nil, &cvPixelBuffer)
        
        let context = CIContext(options: [.cacheIntermediates: false])
        context.render(CIImage(cgImage: testCGImage), to: cvPixelBuffer!)

        let buffer = VideoFramePixelBuffer(pixelBuffer: cvPixelBuffer!)
        let frame = VideoFrame(timestampNs: 0, rotation: .rotation0, buffer: buffer)
        return frame
    }
}
