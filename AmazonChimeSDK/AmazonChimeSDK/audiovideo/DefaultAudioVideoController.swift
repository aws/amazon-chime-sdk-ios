//
//  DefaultAudioVideoController.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AVFoundation
import Foundation

@objcMembers public class DefaultAudioVideoController: AudioVideoControllerFacade {
    public let configuration: MeetingSessionConfiguration
    public let logger: Logger

    private let audioClientController: AudioClientController
    private let audioClientObserver: AudioClientObserver
    private let clientMetricsCollector: ClientMetricsCollector
    private var videoClientController: VideoClientController

    public init(audioClientController: AudioClientController,
                audioClientObserver: AudioClientObserver,
                clientMetricsCollector: ClientMetricsCollector,
                videoClientController: VideoClientController,
                configuration: MeetingSessionConfiguration,
                logger: Logger) {
        self.audioClientController = audioClientController
        self.audioClientObserver = audioClientObserver
        self.clientMetricsCollector = clientMetricsCollector
        self.videoClientController = videoClientController
        self.configuration = configuration
        self.logger = logger
    }

    public func start() throws {
        let audioPermissionStatus = AVAudioSession.sharedInstance().recordPermission
        if audioPermissionStatus == .denied || audioPermissionStatus == .undetermined {
            throw PermissionError.audioPermissionError
        }

        try audioClientController.start(audioFallbackUrl: configuration.urls.audioFallbackUrl,
                                    audioHostUrl: configuration.urls.audioHostUrl,
                                    meetingId: configuration.meetingId,
                                    attendeeId: configuration.credentials.attendeeId,
                                    joinToken: configuration.credentials.joinToken)
        videoClientController.start(turnControlUrl: configuration.urls.turnControlUrl,
                                        signalingUrl: configuration.urls.signalingUrl,
                                        meetingId: configuration.meetingId,
                                        joinToken: configuration.credentials.joinToken)
    }

    public func stop() {
        audioClientController.stop()
        videoClientController.stopAndDestroy()
    }

    public func addAudioVideoObserver(observer: AudioVideoObserver) {
        audioClientObserver.subscribeToAudioClientStateChange(observer: observer)
        videoClientController.subscribeToVideoClientStateChange(observer: observer)
    }

    public func removeAudioVideoObserver(observer: AudioVideoObserver) {
        audioClientObserver.unsubscribeFromAudioClientStateChange(observer: observer)
        videoClientController.unsubscribeToVideoClientStateChange(observer: observer)
    }

    public func addMetricsObserver(observer: MetricsObserver) {
        clientMetricsCollector.subscribeToMetrics(observer: observer)
    }

    public func removeMetricsObserver(observer: MetricsObserver) {
        clientMetricsCollector.unsubscribeFromMetrics(observer: observer)
    }

    public func startLocalVideo() throws {
        try videoClientController.startLocalVideo()
    }

    public func stopLocalVideo() {
        videoClientController.stopLocalVideo()
    }

    public func startRemoteVideo() {
        videoClientController.startRemoteVideo()
    }

    public func stopRemoteVideo() {
        videoClientController.stopRemoteVideo()
    }
}
