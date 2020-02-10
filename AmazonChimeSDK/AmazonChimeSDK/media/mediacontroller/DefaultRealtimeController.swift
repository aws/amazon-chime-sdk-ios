//
//  DefaultRealtimeControllerFacade.swift
//  AmazonChimeSDK
//
//  Created by Hwang, Hokyung on 1/22/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
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
