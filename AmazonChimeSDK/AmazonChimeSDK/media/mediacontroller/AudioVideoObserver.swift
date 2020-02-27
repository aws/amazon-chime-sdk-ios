//
//  AudioVideoObserver.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

public protocol AudioVideoObserver {
    /// Called when the audio session is connecting or reconnecting.
    ///
    /// - Parameter reconnecting: Whether the session is reconnecting or not.
    func onAudioClientConnecting(reconnecting: Bool)

    /// Called when the audio session has started.
    ///
    /// - Parameter reconnecting: Whether the session is reconnecting or not.
    func onAudioClientStart(reconnecting: Bool)

    /// Called when the audio session has stopped from a started state with the reason
    /// provided in the status.
    ///
    /// - Parameter sessionStatus: The reason why the session has stopped.
    func onAudioClientStop(sessionStatus: MeetingSessionStatus)

    /// Called when the audio reconnection is canceled.
    func onAudioClientReconnectionCancel()

    /// Called when the connection health is recovered.
    func onConnectionRecover()

    /// Called when connection is becoming poor.
    func onConnectionBecomePoor()

    /// Called when the video session is connecting or reconnecting.
    func onVideoClientConnecting()

    /// Called when the video session has started.
    func onVideoClientStart()

    /// Called when the video session has stopped from a started state with the reason
    /// provided in the status.
    ///
    /// - Parameter sessionStatus: The reason why the session has stopped.
    func onVideoClientStop(sessionStatus: MeetingSessionStatus)
}
