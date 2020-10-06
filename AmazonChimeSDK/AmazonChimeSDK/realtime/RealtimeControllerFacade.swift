//
//  RealtimeControllerFacade.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `RealtimeControllerFacade` controls aspects meetings concerning realtime UX
/// that for performance, privacy, or other reasons should be implemented using
/// the most direct path. Callbacks generated by this interface should be
/// consumed synchronously and without business logic dependent on the UI state
/// where possible.
///
/// Events will be passed through `RealtimeObserver`, which in turn provides consumers the
/// volume/mute/signal/attendee callbacks that can be used to render in the UI.
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

    /// Subscribes to data meesage event with an observer
    ///
    /// - Parameter topic: Topic to handle
    /// - Parameter observer: Observer that handles data message event with given topic
    func addRealtimeDataMessageObserver(topic: String, observer: DataMessageObserver)

    /// Unsubscribes from data meesage event by removing the specified observer by topic
    ///
    /// - Parameter topic: Topic to remove
    func removeRealtimeDataMessageObserverFromTopic(topic: String)

    /// Send arbitrary data to given topic with given lifetime ms (5 mins max)
    ///
    /// - Parameter topic: Topic to send
    /// - Parameter data: Data to send, data can be either a String or JSON serializable object
    /// - Parameter lifetimeMs: Message lifetime in milisecond, 5 mins max, default 0
    /// - Throws: SendDataMessageError
    func realtimeSendDataMessage(topic: String, data: Any, lifetimeMs: Int32) throws

    /// Toggle Voice Focus (ML-based noise suppression) on/off
    ///
    /// Note: this API can only be called after audio session was started.
    ///
    /// - Parameter on: A `Bool` value, where `true` to toggle on, `false` to toggle off
    /// - Returns: Whether toggle was successful
    func realtimeToggleVoiceFocus(on: Bool) -> Bool

    /// Get if Voice Focus (ML-based noise suppression) is on or not
    ///
    /// - Returns: `true` if Voice Focus is running; `false` if Voice Focus is not running
    func realtimeIsVoiceFocusOn() -> Bool
}
