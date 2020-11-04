//
//  VideoCaptureFormat.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AVFoundation

/// `VideoCaptureFormat`describes a given capture format that may be possible to apply to a `VideoCaptureSource`.
/// Note that `VideoCaptureSource` implementations may ignore or adjust unsupported values.
@objc public class VideoCaptureFormat: NSObject {
    /// Capture width in pixels.
    public let width: Int

    /// Capture height in pixels.
    public let height: Int

    /// Max frame rate. When used as input this implies the desired frame rate as well.
    public let maxFrameRate: Int

    public init(width: Int, height: Int, maxFrameRate: Int) {
        self.width = width
        self.height = height
        self.maxFrameRate = maxFrameRate
    }

    override public func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? VideoCaptureFormat else {
            return false
        }
        return width == object.width
            && height == object.height
            && maxFrameRate == object.maxFrameRate
    }

    /// Helper function to convert `AVCaptureDevice.Format` to `VideoCaptureFormat`
    /// - Parameter avFormat: format from the `AVCaptureDevice`
    public static func fromAVCaptureDeviceFormat(format: AVCaptureDevice.Format) -> VideoCaptureFormat {
        let dimensions = CMVideoFormatDescriptionGetDimensions(format.formatDescription)
        var maxFPS = Constants.maxSupportedVideoFrameRate
        let frameRateRanges = format.videoSupportedFrameRateRanges
        let range = frameRateRanges.min { Int($0.maxFrameRate) < Int($1.maxFrameRate) }
        if let range = range {
            maxFPS = Int(range.maxFrameRate)
        }
        return VideoCaptureFormat(width: Int(dimensions.width),
                                  height: Int(dimensions.height),
                                  maxFrameRate: maxFPS)
    }
}
