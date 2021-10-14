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
    func start()
    func stopAndDestroy()
    func startLocalVideo() throws
    func startLocalVideo(source: VideoSource)
    func stopLocalVideo()
    func startRemoteVideo()
    func stopRemoteVideo()
    func switchCamera()
    func getCurrentDevice() -> MediaDevice?
    func getConfiguration() -> MeetingSessionConfiguration
    func subscribeToVideoClientStateChange(observer: AudioVideoObserver)
    func unsubscribeFromVideoClientStateChange(observer: AudioVideoObserver)
    func subscribeToVideoTileControllerObservers(observer: VideoTileController)
    func unsubscribeFromVideoTileControllerObservers(observer: VideoTileController)
    func pauseResumeRemoteVideo(_ videoId: UInt32, pause: Bool)
    func subscribeToReceiveDataMessage(topic: String, observer: DataMessageObserver)
    func unsubscribeFromReceiveDataMessageFromTopic(topic: String)
    func sendDataMessage(topic: String, data: Any, lifetimeMs: Int32) throws
    func updateVideoSourceSubscriptions(addedOrUpdated: Dictionary<RemoteVideoSource, VideoSubscriptionConfiguration>, removed: Array<RemoteVideoSource>)
    func promoteToPrimaryMeeting(credentials: MeetingSessionCredentials,
                                 observer: PrimaryMeetingPromotionObserver)
    func demoteFromPrimaryMeeting()
}
