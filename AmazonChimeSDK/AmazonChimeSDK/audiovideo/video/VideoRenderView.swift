//
//  VideoRenderView.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import VideoToolbox

/// `VideoRenderView` is the type of VideoSink used by the `VideoTileController`
@objc public protocol VideoRenderView: VideoSink {}
