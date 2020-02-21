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
    let videoTileController: VideoTileController

    init(
        audioVideoController: AudioVideoControllerFacade,
        realtimeController: RealtimeControllerFacade,
        deviceController: DeviceController,
        videoTileController: VideoTileController
    ) {
        self.audioVideoController = audioVideoController
        self.realtimeController = realtimeController
        self.deviceController = deviceController
        self.videoTileController = videoTileController

        self.configuration = audioVideoController.configuration
        self.logger = audioVideoController.logger
    }

    public func start() throws {
        try self.audioVideoController.start()
        self.trace(name: "start")
    }

    public func stop() {
        self.audioVideoController.stop()
        self.trace(name: "stop")
    }

    public func startLocalVideo() throws {
        try self.audioVideoController.startLocalVideo()
    }

    public func stopLocalVideo() {
        self.audioVideoController.stopLocalVideo()
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

    public func switchCamera() {
        self.deviceController.switchCamera()
    }

    public func getActiveCamera() -> MediaDevice? {
        return self.deviceController.getActiveCamera()
    }

    // MARK: VideoTileController

    public func bindVideoView(videoView: VideoRenderView, tileId: Int) {
        self.videoTileController.bindVideoView(videoView: videoView, tileId: tileId)
    }

    public func unbindVideoView(tileId: Int) {
        self.videoTileController.unbindVideoView(tileId: tileId)
    }

    public func addVideoTileObserver(observer: VideoTileObserver) {
        self.videoTileController.addVideoTileObserver(observer: observer)
    }

    public func removeVideoTileObserver(observer: VideoTileObserver) {
        self.videoTileController.removeVideoTileObserver(observer: observer)
    }

    public func pauseVideoTile(tileId: Int) {
        self.videoTileController.pauseVideoTile(tileId: tileId)
    }

    public func unpauseVideoTile(tileId: Int) {
        self.videoTileController.unpauseVideoTile(tileId: tileId)
    }
}
