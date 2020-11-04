//
//  VideoRotation.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDKMedia
import Foundation

/// `VideoRotation` describes the rotation of the video frame buffer in degrees clockwise
/// from intended viewing horizon.
///
/// e.g. If you were recording camera capture upside down relative to
/// the orientation of the sensor, this value would be `VideoRotation.rotation180`.
@objc public enum VideoRotation: Int {
    /// Not rotated.
    case rotation0 = 0

    /// Rotated 90 degrees clockwise.
    case rotation90 = 90

    /// Rotated 180 degrees clockwise.
    case rotation180 = 180

    /// Rotated 270 degrees clockwise.
    case rotation270 = 270

    var toInternal: VideoRotationInternal {
        return VideoRotationInternal(rawValue: UInt(rawValue)) ?? .rotation0
    }

    init(internalValue: VideoRotationInternal) {
        self = VideoRotation(rawValue: Int(internalValue.rawValue)) ?? .rotation0
    }

    var description: String {
        switch self {
        case .rotation0:
            return "rotation_0"
        case .rotation90:
            return "rotation_90"
        case .rotation180:
            return "rotation_180"
        case .rotation270:
            return "rotation_270"
        }
    }
}
