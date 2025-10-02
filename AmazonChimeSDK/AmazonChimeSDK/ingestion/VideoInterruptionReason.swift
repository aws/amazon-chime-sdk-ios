//
//  VideoInterruptionReason.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AmazonChimeSDKMedia
import AVFoundation

@objc public enum VideoInterruptionReason: Int, Error, CustomStringConvertible {
    
    case videoDeviceNotAvailableInBackground
    case videoDeviceInUseByAnotherClient
    case videoDeviceNotAvailableWithMultipleForegroundApps
    case videoDeviceNotAvailableDueToSystemPressure
    case other
    
    public init(from reason: AVCaptureSession.InterruptionReason) {
        switch reason {
        case AVCaptureSession.InterruptionReason.videoDeviceNotAvailableInBackground:
            self = .videoDeviceNotAvailableInBackground
        case AVCaptureSession.InterruptionReason.videoDeviceInUseByAnotherClient:
            self = .videoDeviceInUseByAnotherClient
        case AVCaptureSession.InterruptionReason.videoDeviceNotAvailableWithMultipleForegroundApps:
            self = .videoDeviceNotAvailableWithMultipleForegroundApps
        case AVCaptureSession.InterruptionReason.videoDeviceNotAvailableDueToSystemPressure:
            self = .videoDeviceNotAvailableDueToSystemPressure
        default:
            self = .other
        }
    }

    public var description: String {
        switch self {
        case .videoDeviceNotAvailableInBackground:
            return "videoDeviceNotAvailableInBackground"
        case .videoDeviceInUseByAnotherClient:
            return "videoDeviceInUseByAnotherClient"
        case .videoDeviceNotAvailableWithMultipleForegroundApps:
            return "notInitialized"
        case .videoDeviceNotAvailableDueToSystemPressure:
            return "videoDeviceNotAvailableDueToSystemPressure"
        case .other:
            return "other"
        }
    }
}
