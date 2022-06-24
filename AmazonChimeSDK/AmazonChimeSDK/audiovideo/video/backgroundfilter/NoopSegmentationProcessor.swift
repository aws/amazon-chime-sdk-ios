//
//  NoopSegmentationProcessor.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `NoopSegmentationProcessor` is a processor that does nothing except pass image frames in and out.
/// This is used as a placeholder for implementations of `SegmentationProcessor` that cannot be initialized.
public class NoopSegmentationProcessor: SegmentationProcessor {
    private var buffer: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer<UInt8>.allocate(capacity: 0)

    public func initialize(withHeight: Int, width: Int, channels: Int) -> Bool {
        let capacity = withHeight * width * Int(channels)
        buffer = UnsafeMutablePointer.allocate(capacity: capacity)
        return true
    }

    public func predict() -> Bool {
        return true
    }

    public func getModelState() -> Int {
        return Int(CwtModelState.LOADED.rawValue)
    }

    public func getInputBuffer() -> UnsafeMutablePointer<UInt8> {
        return buffer
    }

    public func getOutputBuffer() -> UnsafeMutablePointer<UInt8> {
        return buffer
    }
}
