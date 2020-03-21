//
//  DefaultRealtimeController.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

@objcMembers public class DefaultRealtimeController: RealtimeControllerFacade {
    private let audioClientController: AudioClientController
    private let audioClientObserver: AudioClientObserver

    public init(audioClientController: AudioClientController,
                audioClientObserver: AudioClientObserver) {
        self.audioClientController = audioClientController
        self.audioClientObserver = audioClientObserver
    }

    public func realtimeLocalMute() -> Bool {
        return audioClientController.setMute(mute: true)
    }

    public func realtimeLocalUnmute() -> Bool {
        return audioClientController.setMute(mute: false)
    }

    public func addRealtimeObserver(observer: RealtimeObserver) {
        audioClientObserver.subscribeToRealTimeEvents(observer: observer)
    }

    public func removeRealtimeObserver(observer: RealtimeObserver) {
        audioClientObserver.unsubscribeFromRealTimeEvents(observer: observer)
    }
}
