//
//  DefaultRealtimeController.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
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
