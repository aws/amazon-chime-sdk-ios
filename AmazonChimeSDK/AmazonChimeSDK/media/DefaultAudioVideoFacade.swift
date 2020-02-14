//
//  DefaultAudioVideoFacade.swift
//  SwiftTest
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

public class DefaultAudioVideoFacade: AudioVideoFacade {
    public let configuration: MeetingSessionConfiguration
    public let logger: Logger

    let audioVideoController: AudioVideoControllerFacade
    let realtimeController: RealtimeControllerFacade
    let deviceController: DeviceController

    init(
        audioVideoController: AudioVideoControllerFacade,
        realtimeController: RealtimeControllerFacade,
        deviceController: DeviceController) {
        self.audioVideoController = audioVideoController
        self.realtimeController = realtimeController
        self.deviceController = deviceController

        self.configuration = audioVideoController.configuration
        self.logger = ConsoleLogger(name: "DefaultAudioVideoFacade")
    }

    public func start() throws {
        try self.audioVideoController.start()
        self.trace(name: "start")
    }

    public func stop() {
        self.audioVideoController.stop()
        self.trace(name: "stop")
    }

    private func trace(name: String) {
        let message = "API/DefaultAudioVideoFacade/\(name)"
        self.audioVideoController.logger.info(msg: message)
    }

    // MARK: RealtimeControllerFacade

    public func realtimeLocalMute() -> Bool {
        return self.realtimeController.realtimeLocalMute()
    }

    public func realtimeLocalUnmute() -> Bool {
        return self.realtimeController.realtimeLocalUnmute()
    }

    public func realtimeAddObserver(observer: RealtimeObserver) {
        self.realtimeController.realtimeAddObserver(observer: observer)
    }

    public func realtimeRemoveObserver(observer: RealtimeObserver) {
        self.realtimeController.realtimeRemoveObserver(observer: observer)
    }

    public func addObserver(observer: AudioVideoObserver) {
        self.audioVideoController.addObserver(observer: observer)
    }

    public func removeObserver(observer: AudioVideoObserver) {
        self.audioVideoController.removeObserver(observer: observer)
    }

    // MARK: DeviceController
    public func listAudioDevices() -> [MediaDevice] {
        return self.deviceController.listAudioDevices()
    }

    public func chooseAudioDevice(mediaDevice: MediaDevice) {
        self.deviceController.chooseAudioDevice(mediaDevice: mediaDevice)
    }

    public func addDeviceChangeObserver(observer: DeviceChangeObserver) {
        self.deviceController.addDeviceChangeObserver(observer: observer)
    }

    public func removeDeviceChangeObserver(observer: DeviceChangeObserver) {
        self.deviceController.removeDeviceChangeObserver(observer: observer)
    }
}
