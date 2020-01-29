//
//  DefaultAudioVideoFacade.swift
//  SwiftTest
//
//  Created by Xu, Tianyu on 1/10/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

import Foundation

public class DefaultAudioVideoFacade: AudioVideoFacade {
    public let configuration: MeetingSessionConfiguration
    public let logger: Logger

    let audioVideoController: AudioVideoControllerFacade
    let realTimeController: RealtimeControllerFacade

    init(audioVideoController: AudioVideoControllerFacade, realTimeController: RealtimeControllerFacade) {
        self.audioVideoController = audioVideoController
        self.realTimeController = realTimeController
        configuration = audioVideoController.configuration
        logger = ConsoleLogger(name: "DefaultAudioVideoFacade")
    }

    public func start() {
        self.audioVideoController.start()
        trace(name: "start")
    }

    public func stop() {
        self.audioVideoController.stop()
        trace(name: "stop")
    }

    private func trace(name: String) {
        let message = "API/DefaultAudioVideoFacade/\(name)"
        self.audioVideoController.logger.info(msg: message)
    }

    // MARK: RealtimeControllerFacade
    public func realtimeLocalMute() -> Bool {
        return self.realTimeController.realtimeLocalMute()
    }

    public func realtimeLocalUnmute() -> Bool {
        return self.realTimeController.realtimeLocalUnmute()
    }

    public func realtimeSubscribeToVolumeIndicator(callback: @escaping ([String: Int]) -> Void) {
        self.realTimeController.realtimeSubscribeToVolumeIndicator(callback: callback)
    }

    public func realtimeUnsubscribeFromVolumeIndicator(callback: @escaping ([String: Int]) -> Void) {
        self.realTimeController.realtimeUnsubscribeFromVolumeIndicator(callback: callback)
    }

    public func realtimeSubscribeToSignalStrengthChange(callback: @escaping ([String: Int]) -> Void) {
        self.realTimeController.realtimeSubscribeToSignalStrengthChange(callback: callback)
    }

    public func realtimeUnsubscribeFromSignalStrengthChange(callback: @escaping ([String: Int]) -> Void) {
        self.realTimeController.realtimeSubscribeToSignalStrengthChange(callback: callback)
    }
}
