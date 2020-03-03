//
//  RealtimeControllerFacade.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

@objc public protocol RealtimeControllerFacade {
    /// Mutes the audio input.
    ///
    /// - Returns: Whether mute was successful
    func realtimeLocalMute() -> Bool

    /// Unmutes the audio input if currently allowed
    ///
    /// - Returns: Whether unmute was successful
    func realtimeLocalUnmute() -> Bool

    /// Subscribes to real time events with an observer
    ///
    /// - Parameter observer: Observer that handles real time events
    func addRealtimeObserver(observer: RealtimeObserver)

    /// Unsubscribes from real time events by removing the specified observer
    ///
    /// - Parameter observer: Observer that handles real time events
    func removeRealtimeObserver(observer: RealtimeObserver)
}
