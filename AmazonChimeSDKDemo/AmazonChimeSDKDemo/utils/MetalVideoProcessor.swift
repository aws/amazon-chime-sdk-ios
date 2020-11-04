//
//  MetalVideoProcessor.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import CoreVideo
import Foundation
import Metal
import MetalPerformanceShaders

// This processor is not available on Apple A7 and older chips
// since it uses MetalPerformanceShaders.
class MetalVideoProcessor: VideoSource, VideoSink {
    var videoContentHint = VideoContentHint.motion

    private let device: MTLDevice
    // Cache for textures created from CVPixelBuffers
    private let textureCache: CVMetalTextureCache
    // The command queue used to pass commands to the device.
    private let commandQueue: MTLCommandQueue
    private let sinks = NSMutableSet()

    private var bufferPool: CVPixelBufferPool?
    private var bufferPoolWidth: Int = 0
    private var bufferPoolHeight: Int = 0

    init?() {
        // Initialize metal state and caches
        guard let defaultDevice = MTLCreateSystemDefaultDevice(),
            defaultDevice.supportsFeatureSet(.iOS_GPUFamily2_v1) else {
            return nil
        }
        device = defaultDevice
        var metalTextureCache: CVMetalTextureCache?
        CVMetalTextureCacheCreate(nil, nil, device, nil, &metalTextureCache)
        guard let cache = metalTextureCache else {
            return nil
        }
        textureCache = cache
        guard let queue = device.makeCommandQueue() else {
            return nil
        }
        commandQueue = queue
    }

    func addVideoSink(sink: VideoSink) {
        sinks.add(sink)
    }

    func removeVideoSink(sink: VideoSink) {
        sinks.remove(sink)
    }

    func onVideoFrameReceived(frame: VideoFrame) {
        let pixelBuffer = (frame.buffer as? VideoFramePixelBuffer)!
        let inputBuffer = pixelBuffer.pixelBuffer

        if bufferPool == nil || frame.width != bufferPoolWidth || frame.height != bufferPoolHeight {
            updateBufferPool(newWidth: frame.width, newHeight: frame.height)
        }
        var outputBuffer: CVPixelBuffer?
        CVPixelBufferPoolCreatePixelBuffer(nil, bufferPool!, &outputBuffer)
        let validOutputBuffer = outputBuffer!

        // For simplicity, we only support NV12 frames
        let pixelFormat = CVPixelBufferGetPixelFormatType(inputBuffer)
        if pixelFormat != kCVPixelFormatType_420YpCbCr8BiPlanarFullRange,
            pixelFormat != kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange {
            return
        }

        // Create textures from input and output pixel buffers
        let inputLumaTexture = createTexutreFromBuffer(pixelBuffer: inputBuffer,
                                                       plane: 0,
                                                       format: MTLPixelFormat.r8Unorm)!
        let inputChromaTexture = createTexutreFromBuffer(pixelBuffer: inputBuffer,
                                                         plane: 1,
                                                         format: MTLPixelFormat.rg8Unorm)!

        let outputLumaTexture = createTexutreFromBuffer(pixelBuffer: validOutputBuffer,
                                                        plane: 0,
                                                        format: MTLPixelFormat.r8Unorm)!
        let outputChromaTexture = createTexutreFromBuffer(pixelBuffer: validOutputBuffer,
                                                          plane: 1,
                                                          format: MTLPixelFormat.rg8Unorm)!

        // For simplicity, we just use a MetalPerformanceShader here on each of the planes
        // but using a custom shader should be similarly straightforward
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let gaussianBlur = MPSImageGaussianBlur(device: device, sigma: 16)
        gaussianBlur.edgeMode = MPSImageEdgeMode.clamp
        gaussianBlur.encode(commandBuffer: commandBuffer,
                            sourceTexture: inputLumaTexture,
                            destinationTexture: outputLumaTexture)
        gaussianBlur.encode(commandBuffer: commandBuffer,
                            sourceTexture: inputChromaTexture,
                            destinationTexture: outputChromaTexture)
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()

        let processedFrame = VideoFrame(timestampNs: frame.timestampNs,
                                        rotation: frame.rotation,
                                        buffer: VideoFramePixelBuffer(pixelBuffer: validOutputBuffer))
        for sink in sinks {
            (sink as? VideoSink)?.onVideoFrameReceived(frame: processedFrame)
        }
    }

    private func updateBufferPool(newWidth: Int, newHeight: Int) {
        var attributes: [NSString: NSObject] = [:]
        attributes[kCVPixelBufferPixelFormatTypeKey] =
            NSNumber(value: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange))
        attributes[kCVPixelBufferWidthKey] = NSNumber(value: newWidth)
        attributes[kCVPixelBufferHeightKey] = NSNumber(value: newHeight)
        attributes[kCVPixelBufferIOSurfacePropertiesKey] = [:] as NSObject
        CVPixelBufferPoolCreate(nil, nil, attributes as CFDictionary?, &bufferPool)

        bufferPoolWidth = newWidth
        bufferPoolHeight = newHeight
    }

    private func createTexutreFromBuffer(pixelBuffer: CVPixelBuffer,
                                         plane: Int,
                                         format: MTLPixelFormat) -> MTLTexture? {
        let width = CVPixelBufferGetWidthOfPlane(pixelBuffer, plane)
        let height = CVPixelBufferGetHeightOfPlane(pixelBuffer, plane)

        var metalTextureRef: CVMetalTexture?
        var texture: MTLTexture?
        let status = CVMetalTextureCacheCreateTextureFromImage(
            kCFAllocatorDefault,
            textureCache,
            pixelBuffer,
            nil,
            format,
            width,
            height,
            plane,
            &metalTextureRef
        )
        if status == kCVReturnSuccess {
            if let metalTextureRef = metalTextureRef {
                texture = CVMetalTextureGetTexture(metalTextureRef)
            }
        }
        return texture
    }
}
