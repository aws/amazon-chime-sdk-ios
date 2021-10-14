//
//  DefaultAudioVideoFacade.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers public class DefaultAudioVideoFacade: NSObject, AudioVideoFacade {
    public let configuration: MeetingSessionConfiguration
    public let logger: Logger

    let audioVideoController: AudioVideoControllerFacade
    let realtimeController: RealtimeControllerFacade
    let deviceController: DeviceController
    let videoTileController: VideoTileController
    let activeSpeakerDetector: ActiveSpeakerDetectorFacade
    let contentShareController: ContentShareController
    let eventAnalyticsController: EventAnalyticsController

    public init(
        audioVideoController: AudioVideoControllerFacade,
        realtimeController: RealtimeControllerFacade,
        deviceController: DeviceController,
        videoTileController: VideoTileController,
        activeSpeakerDetector: ActiveSpeakerDetectorFacade,
        contentShareController: ContentShareController,
        eventAnalyticsController: EventAnalyticsController,
        meetingStatsCollector: MeetingStatsCollector
    ) {
        self.audioVideoController = audioVideoController
        self.realtimeController = realtimeController
        self.deviceController = deviceController
        self.videoTileController = videoTileController
        self.configuration = audioVideoController.configuration
        self.logger = audioVideoController.logger
        self.activeSpeakerDetector = activeSpeakerDetector
        self.contentShareController = contentShareController
        self.eventAnalyticsController = eventAnalyticsController
    }

    public func start(audioVideoConfiguration: AudioVideoConfiguration) throws {
        try audioVideoController.start(audioVideoConfiguration: audioVideoConfiguration)

        trace(name: "start(audioVideoConfiguration: \(audioVideoConfiguration))")
    }

    public func start(callKitEnabled: Bool = false) throws {
        try self.start(audioVideoConfiguration: AudioVideoConfiguration(callKitEnabled: callKitEnabled))
    }

    public func start() throws {
        try self.start(audioVideoConfiguration: AudioVideoConfiguration())
    }

    public func stop() {
        audioVideoController.stop()
        trace(name: "stop")
    }

    public func startLocalVideo() throws {
        try audioVideoController.startLocalVideo()
    }

    public func startLocalVideo(source: VideoSource) {
        audioVideoController.startLocalVideo(source: source)
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

    public func addRealtimeDataMessageObserver(topic: String, observer: DataMessageObserver) {
        realtimeController.addRealtimeDataMessageObserver(topic: topic, observer: observer)
    }

    public func removeRealtimeDataMessageObserverFromTopic(topic: String) {
        realtimeController.removeRealtimeDataMessageObserverFromTopic(topic: topic)
    }

    public func realtimeSendDataMessage(topic: String, data: Any, lifetimeMs: Int32 = 0) throws {
        try realtimeController.realtimeSendDataMessage(topic: topic, data: data, lifetimeMs: lifetimeMs)
    }

    public func realtimeSetVoiceFocusEnabled(enabled: Bool) -> Bool {
        return realtimeController.realtimeSetVoiceFocusEnabled(enabled: enabled)
    }

    public func realtimeIsVoiceFocusEnabled() -> Bool {
        return realtimeController.realtimeIsVoiceFocusEnabled()
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

    public func addRealtimeTranscriptEventObserver(observer: TranscriptEventObserver) {
        realtimeController.addRealtimeTranscriptEventObserver?(observer: observer)
    }

    public func removeRealtimeTranscriptEventObserver(observer: TranscriptEventObserver) {
        realtimeController.removeRealtimeTranscriptEventObserver?(observer: observer)
    }
    
    public func updateVideoSourceSubscriptions(addedOrUpdated: Dictionary<RemoteVideoSource, VideoSubscriptionConfiguration>, removed: Array<RemoteVideoSource>) {
        audioVideoController.updateVideoSourceSubscriptions(addedOrUpdated: addedOrUpdated, removed: removed)
    }

    public func promoteToPrimaryMeeting(credentials: MeetingSessionCredentials, observer: PrimaryMeetingPromotionObserver) {
        audioVideoController.promoteToPrimaryMeeting(credentials: credentials, observer: observer)
    }

    public func demoteFromPrimaryMeeting() {
        audioVideoController.demoteFromPrimaryMeeting()
        // Stop content share as well
        contentShareController.stopContentShare()
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

    public func getActiveAudioDevice() -> MediaDevice? {
        return deviceController.getActiveAudioDevice()
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

    // MARK: ContentShareController

    public func startContentShare(source: ContentShareSource) {
        contentShareController.startContentShare(source: source)
    }

    public func stopContentShare() {
        contentShareController.stopContentShare()
    }

    public func addContentShareObserver(observer: ContentShareObserver) {
        contentShareController.addContentShareObserver(observer: observer)
    }

    public func removeContentShareObserver(observer: ContentShareObserver) {
        contentShareController.removeContentShareObserver(observer: observer)
    }

    public func addEventAnalyticsObserver(observer: EventAnalyticsObserver) {
        eventAnalyticsController.addEventAnalyticsObserver(observer: observer)
    }

    public func removeEventAnalyticsObserver(observer: EventAnalyticsObserver) {
        eventAnalyticsController.removeEventAnalyticsObserver(observer: observer)
    }

    public func getMeetingHistory() -> [MeetingHistoryEvent] {
        return eventAnalyticsController.getMeetingHistory()
    }

    public func getCommonEventAttributes() -> [AnyHashable: Any] {
        return eventAnalyticsController.getCommonEventAttributes()
    }
}
