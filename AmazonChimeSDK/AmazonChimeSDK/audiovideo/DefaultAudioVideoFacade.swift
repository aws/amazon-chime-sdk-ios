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
        try audioVideoController.start()
        trace(name: "start")
    }

    public func stop() {
        audioVideoController.stop()
        trace(name: "stop")
    }

    public func startLocalVideo() throws {
        try audioVideoController.startLocalVideo()
    }

    public func stopLocalVideo() {
        audioVideoController.stopLocalVideo()
    }

    public func startRemoteVideo() {
        audioVideoController.startRemoteVideo()
    }

    public func stopRemoteVideo() {
        audioVideoController.stopRemoteVideo()
    }

    private func trace(name: String) {
        let message = "API/DefaultAudioVideoFacade/\(name)"
        audioVideoController.logger.info(msg: message)
    }

    // MARK: RealtimeControllerFacade

    public func realtimeLocalMute() -> Bool {
        return realtimeController.realtimeLocalMute()
    }

    public func realtimeLocalUnmute() -> Bool {
        return realtimeController.realtimeLocalUnmute()
    }

    public func addRealtimeObserver(observer: RealtimeObserver) {
        realtimeController.addRealtimeObserver(observer: observer)
    }

    public func removeRealtimeObserver(observer: RealtimeObserver) {
        realtimeController.removeRealtimeObserver(observer: observer)
    }

    public func addAudioVideoObserver(observer: AudioVideoObserver) {
        audioVideoController.addAudioVideoObserver(observer: observer)
    }

    public func removeAudioVideoObserver(observer: AudioVideoObserver) {
        audioVideoController.removeAudioVideoObserver(observer: observer)
    }

    public func addMetricsObserver(observer: MetricsObserver) {
        audioVideoController.addMetricsObserver(observer: observer)
    }

    public func removeMetricsObserver(observer: MetricsObserver) {
        audioVideoController.removeMetricsObserver(observer: observer)
    }

    // MARK: DeviceController

    public func listAudioDevices() -> [MediaDevice] {
        return deviceController.listAudioDevices()
    }

    public func chooseAudioDevice(mediaDevice: MediaDevice) {
        deviceController.chooseAudioDevice(mediaDevice: mediaDevice)
    }

    public func addDeviceChangeObserver(observer: DeviceChangeObserver) {
        deviceController.addDeviceChangeObserver(observer: observer)
    }

    public func removeDeviceChangeObserver(observer: DeviceChangeObserver) {
        deviceController.removeDeviceChangeObserver(observer: observer)
    }

    public func switchCamera() {
        deviceController.switchCamera()
    }

    public func getActiveCamera() -> MediaDevice? {
        return deviceController.getActiveCamera()
    }

    // MARK: VideoTileController

    public func bindVideoView(videoView: VideoRenderView, tileId: Int) {
        videoTileController.bindVideoView(videoView: videoView, tileId: tileId)
    }

    public func unbindVideoView(tileId: Int) {
        videoTileController.unbindVideoView(tileId: tileId)
    }

    public func addVideoTileObserver(observer: VideoTileObserver) {
        videoTileController.addVideoTileObserver(observer: observer)
    }

    public func removeVideoTileObserver(observer: VideoTileObserver) {
        videoTileController.removeVideoTileObserver(observer: observer)
    }

    public func pauseRemoteVideoTile(tileId: Int) {
        videoTileController.pauseRemoteVideoTile(tileId: tileId)
    }

    public func resumeRemoteVideoTile(tileId: Int) {
        videoTileController.resumeRemoteVideoTile(tileId: tileId)
    }

    // MARK: ActiveSpeakerDetector

    public func addActiveSpeakerObserver(policy: ActiveSpeakerPolicy, observer: ActiveSpeakerObserver) {
        activeSpeakerDetector.addActiveSpeakerObserver(policy: policy, observer: observer)
    }

    public func removeActiveSpeakerObserver(observer: ActiveSpeakerObserver) {
        activeSpeakerDetector.removeActiveSpeakerObserver(observer: observer)
    }

    public func hasBandwidthPriorityCallback(hasBandwidthPriority: Bool) {}
}
