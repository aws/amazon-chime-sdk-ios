//
//  AudioVideoObserver.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `AudioVideoObserver` handles audio/video session events.
@objc public protocol AudioVideoObserver {
    /// Called when the audio session is connecting or reconnecting.
    ///
    /// Note: this callback will be called on main thread.
    ///
    /// - Parameter reconnecting: Whether the session is reconnecting or not.
    func audioSessionDidStartConnecting(reconnecting: Bool)

    /// Called when the audio session has started.
    ///
    /// Note: this callback will be called on main thread.
    ///
    /// - Parameter reconnecting: Whether the session is reconnecting or not.
    func audioSessionDidStart(reconnecting: Bool)

    /// Called when audio session got dropped due to poor network conditions.
    /// There will be an automatic attempt of reconnecting it.
    /// If the reconnection is successful, `onAudioSessionStarted` will be called with value of reconnecting as true
    ///
    /// Note: this callback will be called on main thread.
    func audioSessionDidDrop()

    /// Called when the audio session has stopped with the reason provided in the status.
    /// This callback implies that audio client has stopped permanently for this session
    /// and there will be no attempt of reconnecting it.
    ///
    /// Note: this callback will be called on main thread.
    ///
    /// - Parameter sessionStatus: The reason why the session has stopped.
    func audioSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus)

    /// Called when the audio reconnection is canceled.
    ///
    /// Note: this callback will be called on main thread.
    func audioSessionDidCancelReconnect()

    /// Called when the connection health is recovered.
    ///
    /// Note: this callback will be called on main thread.
    func connectionDidRecover()

    /// Called when connection is becoming poor.
    ///
    /// Note: this callback will be called on main thread.
    func connectionDidBecomePoor()

    /// Called when the video session is connecting or reconnecting.
    ///
    /// Note: this callback will be called on main thread.
    func videoSessionDidStartConnecting()

    /// Called when the video session has started.
    ///
    /// Note: this callback will be called on main thread.
    ///
    /// - Parameter sessionStatus: The status of meeting session
    func videoSessionDidStartWithStatus(sessionStatus: MeetingSessionStatus)

    /// Called when the video session has stopped from a started state with the reason provided in the status.
    ///
    /// Note: this callback will be called on main thread.
    ///
    /// - Parameter sessionStatus: The reason why the session has stopped.
    func videoSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus)
    
    /// Called on the main thread when video sources become available.
    ///
    /// Video sources can be explicitly subscribed to through `updateVideoSourceSubscriptions`.
    /// These should be stored and used when `updateVideoSourceSubscriptions` is called (i.e. you cannot use `RemoteVideoSource` objects created manually). 
    /// See `updateVideoSourceSubscriptions` for more information.
    /// See note in `updateVideoSourceSubscriptions` documentation for information on 
    /// subscription behavior if `updateVideoSourceSubscriptions` is never called.
    ///
    /// - Parameter sources: Array of remote video sources that are available
    func remoteVideoSourcesDidBecomeAvailable(sources: [RemoteVideoSource])
    
    /// Called on the main thread when video sources become unavailable.
    ///
    /// Note that these sources do not need to be removed via `updateVideoSourceSubscriptions`,
    /// as they will be automatically unsubscribed from.
    ///
    /// - Parameter sources: Array of video sources that are unavailable
    func remoteVideoSourcesDidBecomeUnavailable(sources: [RemoteVideoSource])
    
    /// Called on the main thread when video capacity status is updated.
    ///
    /// - Parameter available: True if camera send is available (due to video capacity status), False if not.
    func cameraSendAvailabilityDidChange(available: Bool)
}
