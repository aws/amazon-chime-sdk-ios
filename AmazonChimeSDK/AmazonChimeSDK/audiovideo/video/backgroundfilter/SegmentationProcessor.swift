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

@objc public protocol SegmentationProcessor {
    @objc func initialize(height: Int, width: Int, channels: Int) -> Bool

    @objc func predict() -> Bool

    @objc func getModelState() -> Int

    @objc func getInputBuffer() -> UnsafeMutablePointer<UInt8>

    @objc func getOutputBuffer() -> UnsafeMutablePointer<UInt8>
}
