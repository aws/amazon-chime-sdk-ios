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

    /// Called when the audio session has stopped from a started state with the reason
    /// provided in the status.
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
    /// - Parameter status: The status of meeting session
    func videoSessionDidStartWithStatus(sessionStatus: MeetingSessionStatus)

    /// Called when the video session has stopped from a started state with the reason
    /// provided in the status.
    ///
    /// Note: this callback will be called on main thread.
    ///
    /// - Parameter sessionStatus: The reason why the session has stopped.
    func videoSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus)
}
