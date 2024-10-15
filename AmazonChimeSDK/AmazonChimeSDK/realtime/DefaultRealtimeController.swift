//
//  DefaultRealtimeController.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers public class DefaultRealtimeController: NSObject, RealtimeControllerFacade {
    private let audioClientController: AudioClientController
    private let audioClientObserver: AudioClientObserver
    private let videoClientController: VideoClientController

    public init(audioClientController: AudioClientController,
                audioClientObserver: AudioClientObserver,
                videoClientController: VideoClientController) {
        self.audioClientController = audioClientController
        self.audioClientObserver = audioClientObserver
        self.videoClientController = videoClientController
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

    public func addRealtimeDataMessageObserver(topic: String, observer: DataMessageObserver) {
        videoClientController.subscribeToReceiveDataMessage(topic: topic, observer: observer)
    }

    public func removeRealtimeDataMessageObserverFromTopic(topic: String) {
        videoClientController.unsubscribeFromReceiveDataMessageFromTopic(topic: topic)
    }

    public func realtimeSendDataMessage(topic: String, data: Any, lifetimeMs: Int32 = 0) throws {
        try videoClientController.sendDataMessage(topic: topic, data: data, lifetimeMs: lifetimeMs)
    }

    public func realtimeSetVoiceFocusEnabled(enabled: Bool) -> Bool {
        return audioClientController.setVoiceFocusEnabled(enabled: enabled)
    }

    public func realtimeIsVoiceFocusEnabled() -> Bool {
        return audioClientController.isVoiceFocusEnabled()
    }

    public func addRealtimeTranscriptEventObserver(observer: TranscriptEventObserver) {
        audioClientObserver.subscribeToTranscriptEvent(observer: observer)
    }

    public func removeRealtimeTranscriptEventObserver(observer: TranscriptEventObserver) {
        audioClientObserver.unsubscribeFromTranscriptEvent(observer: observer)
    }
}
