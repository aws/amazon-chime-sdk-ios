//
//  CoreImageVideoProcessor.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import CoreImage
import Foundation

class CoreImageVideoProcessor: VideoSource, VideoSink {
    var videoContentHint = VideoContentHint.motion

    private let context = CIContext()

    private var bufferPool: CVPixelBufferPool?
    private var bufferPoolWidth: Int = 0
    private var bufferPoolHeight: Int = 0

    private let sinks = NSMutableSet()

    func addVideoSink(sink: VideoSink) {
        sinks.add(sink)
    }

    func removeVideoSink(sink: VideoSink) {
        sinks.remove(sink)
    }

    func onVideoFrameReceived(frame: VideoFrame) {
        guard let pixelBuffer = frame.buffer as? VideoFramePixelBuffer else {
            return
        }

        let inputImage = CIImage(cvImageBuffer: pixelBuffer.pixelBuffer)
        let outputImage = inputImage.applyingFilter("CISepiaTone", parameters: [:])

        if bufferPool == nil || frame.width != bufferPoolWidth || frame.height != bufferPoolHeight {
            updateBufferPool(newWidth: frame.width, newHeight: frame.height)
        }

        guard let bufferPool = bufferPool else {
            return
        }
        var outputBuffer: CVPixelBuffer?
        CVPixelBufferPoolCreatePixelBuffer(nil, bufferPool, &outputBuffer)
        guard let validOutputBuffer = outputBuffer else {
            return
        }
        context.render(outputImage, to: validOutputBuffer)

        let processedFrame = VideoFrame(timestampNs: frame.timestampNs,
                                        rotation: frame.rotation,
                                        buffer: VideoFramePixelBuffer(pixelBuffer: validOutputBuffer))

        for sink in sinks {
            (sink as? VideoSink)?.onVideoFrameReceived(frame: processedFrame)
        }
    }

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
}
