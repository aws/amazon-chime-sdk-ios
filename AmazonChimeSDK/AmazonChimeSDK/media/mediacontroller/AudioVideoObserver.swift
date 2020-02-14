//
//  AudioVideoObserver.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

public protocol AudioVideoObserver {
    /// Called when the session is connecting or reconnecting.
    ///
    /// - Parameter reconnecting: Whether the session is reconnecting or not.
    func onAudioVideoStartConnecting(reconnecting: Bool)

    /// Called when the session has started.
    ///
    /// - Parameter reconnecting: Whether the session is reconnecting or not.
    func onAudioVideoStart(reconnecting: Bool)

    /// Called when the session has stopped from a started state with the reason
    /// provided in the status.
    ///
    /// - Parameter sessionStatus: The reason why the session has stopped.
    func onAudioVideoStop(sessionStatus: MeetingSessionStatus)

    /// Called when reconnection is canceled.
    func onAudioReconnectionCancel()

    /// Called when the connection health is recovered.
    func onConnectionRecover()

    /// Called when connection is becoming poor.
    func onConnectionBecomePoor()

    /// Called when metric is received
    func onMetricsReceive()
}
