//
//  VideoClientController.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

public protocol VideoClientController {
    func start(turnControlUrl: String,
               signalingUrl: String,
               meetingId: String,
               joinToken: String,
               sending: Bool) throws
    func stopAndDestroy()
    func enableSelfVideo(isEnabled: Bool) throws
    func switchCamera()
    func getCurrentDevice() -> VideoDevice?
    func subscribeToVideoClientStateChange(observer: AudioVideoObserver)
    func unsubscribeToVideoClientStateChange(observer: AudioVideoObserver)
    func subscribeToVideoTileControllerObservers(observer: VideoTileController)
    func unsubscribeToVideoTileControllerObservers(observer: VideoTileController)
    func pauseResumeRemoteVideo(_ videoId: UInt32, pause: Bool)
}
