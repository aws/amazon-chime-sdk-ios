//
//  CameraCaptureSource.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `CameraCaptureSource` is an interface for camera capture sources with additional features
/// not covered by `VideoCaptureSource`.
/// All the APIs in this protocol can be called regardless of whether the `MeetingSession.audioVideo` is started or not.
@objc public protocol CameraCaptureSource: VideoCaptureSource {
    /// Current camera device. This is only null if the phone/device doesn't have any cameras
    /// May be called regardless of whether `start` or `stop` has been called.
    var device: MediaDevice? { get set }

    /// Toggle for flashlight on the current device. Will succeed if current device has access to
    /// flashlight, otherwise will stay `false`. May be called regardless of whether `start` or `stop`
    /// has been called.
    var torchEnabled: Bool { get set }

    /// Current camera capture format  Actual format may be adjusted to use supported camera formats.
    /// May be called regardless of whether `start` or `stop` has been called.
    var format: VideoCaptureFormat { get set }

    /// Helper function to switch from front to back cameras or reverse. 
    func switchCamera()
}
