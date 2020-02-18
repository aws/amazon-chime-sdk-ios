//
//  DefaultRealtimeControllerFacade.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

public class DefaultRealtimeController: RealtimeControllerFacade {
    let audioClient: AudioClientController

    public init() {
        self.audioClient = AudioClientController.shared()
    }

    public func realtimeLocalMute() -> Bool {
        return audioClient.setMicMute(mute: true)
    }

    public func realtimeLocalUnmute() -> Bool {
        return audioClient.setMicMute(mute: false)
    }

    public func realtimeAddObserver(observer: RealtimeObserver) {
        audioClient.addRealtimeObserver(observer: observer)
    }

    public func realtimeRemoveObserver(observer: RealtimeObserver) {
        audioClient.removeRealtimeObserver(observer: observer)
    }
}
