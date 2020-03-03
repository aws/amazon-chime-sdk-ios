//
//  VideoRenderView.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

@objc public protocol VideoRenderView {
    /// Render given frame to UI
    /// - Parameter frame: a frame of video
    func renderFrame(frame: Any?)
}
