//
//  AudioVideoControllerFacade.swift
//  SwiftTest
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

public protocol AudioVideoControllerFacade {
    var configuration: MeetingSessionConfiguration { get }
    var logger: Logger { get }

    /// Start AudioVideo Controller
    ///
    /// - Throws: `PermissionError.audioPermissionError` if `RecordPermission` is not given
    func start() throws

    /// Stop AudioVideo Controller. This will exit the meeting
    func stop()

    /// Subscribe to audio, video, and connection events with an `AudioVideoObserver`.
    ///
    /// - Parameter observer: The observer to subscribe to events with
    func addObserver(observer: AudioVideoObserver)

    /// Unsubscribes from audio, video, and connection events by removing specified `AudioVideoObserver`.
    ///
    /// - Parameter observer: The observer to unsubscribe from events with
    func removeObserver(observer: AudioVideoObserver)
}
