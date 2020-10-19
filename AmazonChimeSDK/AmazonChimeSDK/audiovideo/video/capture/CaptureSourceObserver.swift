//
//  CaptureSourceObserver.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `CaptureSourceObserver` observes events resulting from different types of capture devices.
/// Builders may desire this input to decide when to show certain UI elements, or to notify users of failure.
@objc public protocol CaptureSourceObserver {
    /// Called when the capture source has started successfully and has started emitting frames.
    func captureDidStart()

    /// Called when the capture source has stopped when expected. This may occur when switching cameras, for example.
    func captureDidStop()

    /// Called when the capture source failed permanently
    /// - Parameters:
    ///   - error: - The reason why the source has stopped.
    func captureDidFail(error: CaptureSourceError)
}
