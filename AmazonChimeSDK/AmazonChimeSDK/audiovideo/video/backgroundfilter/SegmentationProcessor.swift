//
//  SegmentationProcessor.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import CoreImage
import CoreMedia
import Foundation

// IMPORTANT: Any changes that you make to this protocol should be reflected in
// TensorFlowSegmentationProcessor.h. This is because we are force casting the
// protocol type of the TensorFlowSegmentationProcessor class in BackgroundFilterProcessor
// due to an issue when compiling the TensorFlowSegmentationProcessor.h header file
// through bazel. See TensorFlowSegmentationProcessor.h for more details.
@objc public protocol SegmentationProcessor {
    @objc func initialize(height: Int, width: Int, channels: Int) -> Bool

    @objc func predict() -> Bool

    @objc func getModelState() -> Int

    @objc func getInputBuffer() -> UnsafeMutablePointer<UInt8>

    @objc func getOutputBuffer() -> UnsafeMutablePointer<UInt8>
}
