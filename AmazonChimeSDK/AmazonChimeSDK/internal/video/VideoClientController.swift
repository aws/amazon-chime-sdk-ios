//
//  VideoClientController.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDKMedia
import Foundation

@objc public protocol VideoClientController {
    func start(turnControlUrl: String,
               signalingUrl: String,
               meetingId: String,
               joinToken: String)
    func stopAndDestroy()
    func startLocalVideo() throws
    func stopLocalVideo()
    func startRemoteVideo()
    func stopRemoteVideo()
    func switchCamera()
    func getCurrentDevice() -> VideoDevice?
    func subscribeToVideoClientStateChange(observer: AudioVideoObserver)
    func unsubscribeToVideoClientStateChange(observer: AudioVideoObserver)
    func subscribeToVideoTileControllerObservers(observer: VideoTileController)
    func unsubscribeToVideoTileControllerObservers(observer: VideoTileController)
    func pauseResumeRemoteVideo(_ videoId: UInt32, pause: Bool)
}
