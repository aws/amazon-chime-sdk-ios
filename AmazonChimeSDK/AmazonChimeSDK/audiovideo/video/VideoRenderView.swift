//
//  VideoRenderView.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `VideoRenderView` renders frame that comes from `VideoTile`.
@objc public protocol VideoRenderView {
    /// Render given frame to UI
    /// - Parameter frame: a frame of video
    func renderFrame(frame: Any?)
}
