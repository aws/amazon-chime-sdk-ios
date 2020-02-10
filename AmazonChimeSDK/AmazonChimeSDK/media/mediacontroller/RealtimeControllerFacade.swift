//
//  RealtimeControllerFacade.swift
//  AmazonChimeSDK
//
//  Created by Hwang, Hokyung on 1/22/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

import Foundation

public protocol RealtimeControllerFacade {

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
    func realtimeAddObserver(observer: RealtimeObserver)

    /// Unsubscribes from real time events by removing the specified observer
    ///
    /// - Parameter observer: Observer that handles real time events
    func realtimeRemoveObserver(observer: RealtimeObserver)
}
