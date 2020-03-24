//
//  DefaultAudioVideoFacade.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers public class DefaultAudioVideoFacade: AudioVideoFacade {
    public let configuration: MeetingSessionConfiguration
    public let logger: Logger

    let audioVideoController: AudioVideoControllerFacade
    let realtimeController: RealtimeControllerFacade
    let deviceController: DeviceController
    let videoTileController: VideoTileController
    let activeSpeakerDetector: ActiveSpeakerDetectorFacade

    init(
        audioVideoController: AudioVideoControllerFacade,
        realtimeController: RealtimeControllerFacade,
        deviceController: DeviceController,
        videoTileController: VideoTileController,
        activeSpeakerDetector: ActiveSpeakerDetectorFacade
    ) {
        self.audioVideoController = audioVideoController
        self.realtimeController = realtimeController
        self.deviceController = deviceController
        self.videoTileController = videoTileController
        self.configuration = audioVideoController.configuration
        self.logger = audioVideoController.logger
        self.activeSpeakerDetector = activeSpeakerDetector
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

    public func startRemoteVideo() {
        self.audioVideoController.startRemoteVideo()
    }

    public func stopRemoteVideo() {
        self.audioVideoController.stopRemoteVideo()
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

    public func addRealtimeObserver(observer: RealtimeObserver) {
        self.realtimeController.addRealtimeObserver(observer: observer)
    }

    public func removeRealtimeObserver(observer: RealtimeObserver) {
        self.realtimeController.removeRealtimeObserver(observer: observer)
    }

    public func addAudioVideoObserver(observer: AudioVideoObserver) {
        self.audioVideoController.addAudioVideoObserver(observer: observer)
    }

    public func removeAudioVideoObserver(observer: AudioVideoObserver) {
        self.audioVideoController.removeAudioVideoObserver(observer: observer)
    }

    public func addMetricsObserver(observer: MetricsObserver) {
        self.audioVideoController.addMetricsObserver(observer: observer)
    }

    public func removeMetricsObserver(observer: MetricsObserver) {
        self.audioVideoController.removeMetricsObserver(observer: observer)
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

    public func pauseRemoteVideoTile(tileId: Int) {
        self.videoTileController.pauseRemoteVideoTile(tileId: tileId)
    }

    public func resumeRemoteVideoTile(tileId: Int) {
        self.videoTileController.resumeRemoteVideoTile(tileId: tileId)
    }

    // MARK: ActiveSpeakerDetector

    public func addActiveSpeakerObserver(policy: ActiveSpeakerPolicy, observer: ActiveSpeakerObserver) {
        self.activeSpeakerDetector.addActiveSpeakerObserver(policy: policy, observer: observer)
    }

    public func removeActiveSpeakerObserver(observer: ActiveSpeakerObserver) {
        self.activeSpeakerDetector.removeActiveSpeakerObserver(observer: observer)
    }

    public func hasBandwidthPriorityCallback(hasBandwidthPriority: Bool) {}
}
