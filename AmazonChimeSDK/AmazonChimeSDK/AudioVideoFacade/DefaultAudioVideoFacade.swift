//
//  DefaultAudioVideoFacade.swift
//  SwiftTest
//
//  Created by Xu, Tianyu on 1/10/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

import Foundation

public class DefaultAudioVideoFacade: AudioVideoFacade {
    public var configuration: MeetingSessionConfiguration
    public var logger: Logger

    let audioVideoController: AudioVideoControllerFacade
    let realTimeController: RealtimeControllerFacade

    init(audioVideoController: AudioVideoControllerFacade, realTimeController: RealtimeControllerFacade) {
        self.audioVideoController = audioVideoController
        self.realTimeController = realTimeController

        // These two are needed to implement protocol AudioVideoControllerFacade
        logger = ConsoleLogger(name: "DefaultAudioVideoFacade")
        configuration = audioVideoController.configuration
    }

    public func start() {
        self.audioVideoController.start()
        trace(name: "start")
    }

    public func stop() {
        self.audioVideoController.stop()
        trace(name: "stop")
    }
    
    public func realtimeLocalMute() {
        self.realTimeController.realtimeLocalMute()
    }
    
    public func realtimeLocalUnmute() -> Bool {
        return self.realTimeController.realtimeLocalUnmute()
    }

    private func trace(name: String) {
        let message = "API/DefaultAudioVideoFacade/\(name)"
        self.audioVideoController.logger.info(msg: message)
    }
}
