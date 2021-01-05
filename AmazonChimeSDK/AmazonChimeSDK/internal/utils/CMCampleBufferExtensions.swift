//
//  CMCampleBufferExtensions.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import ReplayKit

public extension CMSampleBuffer {
    func getVideoRotation() -> VideoRotation {
        var videoRotation = VideoRotation.rotation0
        // RPVideoSampleOrientationKey is only available on iOS 11+
        if #available(iOS 11.0, *) {
            if let sampleOrientation = CMGetAttachment(self,
                                                       key: RPVideoSampleOrientationKey as CFString,
                                                       attachmentModeOut: nil),
                let coreSampleOrientation = sampleOrientation.uint32Value,
                let orientation = CGImagePropertyOrientation(rawValue: coreSampleOrientation) {
                switch orientation {
                case .left, .leftMirrored:
                    videoRotation = .rotation90
                case .down, .downMirrored:
                    videoRotation = .rotation180
                case .right, .rightMirrored:
                    videoRotation = .rotation270
                default:
                    break
                }
            }
        }
        return videoRotation
    }
}
