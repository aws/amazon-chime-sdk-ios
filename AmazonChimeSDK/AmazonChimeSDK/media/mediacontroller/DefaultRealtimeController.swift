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

    public func realtimeSubscribeToVolumeIndicator(callback: @escaping ([String: Int]) -> Void) {
        audioClient.subscribeToVolumeIndicator(callback: callback)
    }

    public func realtimeSubscribeToSignalStrengthChange(callback: @escaping ([String: Int]) -> Void) {
         audioClient.subscribeToSignalStrengthChange(callback: callback)
    }

    public func realtimeUnsubscribeFromVolumeIndicator(callback: @escaping ([String: Int]) -> Void) {
        audioClient.unsubscribeFromVolumeIndicator(callback: callback)
    }

    public func realtimeUnsubscribeFromSignalStrengthChange(callback: @escaping ([String: Int]) -> Void) {
        audioClient.unsubscribeFromSignalStrengthChange(callback: callback)
    }
}
