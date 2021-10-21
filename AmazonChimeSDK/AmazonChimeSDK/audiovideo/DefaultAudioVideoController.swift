//
//  DefaultAudioVideoController.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AVFoundation
import Foundation

@objcMembers public class DefaultAudioVideoController: NSObject, AudioVideoControllerFacade {
    public let configuration: MeetingSessionConfiguration
    public let logger: Logger

    private let audioClientController: AudioClientController
    private let audioClientObserver: AudioClientObserver
    private let clientMetricsCollector: ClientMetricsCollector
    private var videoClientController: VideoClientController
    private let videoTileController: VideoTileController

    public init(audioClientController: AudioClientController,
                audioClientObserver: AudioClientObserver,
                clientMetricsCollector: ClientMetricsCollector,
                videoClientController: VideoClientController,
                videoTileController: VideoTileController,
                configuration: MeetingSessionConfiguration,
                logger: Logger) {
        self.audioClientController = audioClientController
        self.audioClientObserver = audioClientObserver
        self.clientMetricsCollector = clientMetricsCollector
        self.videoClientController = videoClientController
        self.videoTileController = videoTileController
        self.configuration = configuration
        self.logger = logger
    }

    public func start() throws {
        // By default, start for calls without CallKit integration. Use start(callKitEnabled:)
        // to override the default behavior if the call is integrated with CallKit
        try self.start(audioVideoConfiguration: AudioVideoConfiguration())
    }

    public func start(callKitEnabled: Bool) throws {
        try self.start(audioVideoConfiguration: AudioVideoConfiguration(callKitEnabled: callKitEnabled))
    }

    public func start(audioVideoConfiguration: AudioVideoConfiguration) throws {
        try audioClientController.start(audioFallbackUrl: configuration.urls.audioFallbackUrl,
                                        audioHostUrl: configuration.urls.audioHostUrl,
                                        meetingId: configuration.meetingId,
                                        attendeeId: configuration.credentials.attendeeId,
                                        joinToken: configuration.credentials.joinToken,
                                        callKitEnabled: audioVideoConfiguration.callKitEnabled,
                                        audioMode: audioVideoConfiguration.audioMode)
        videoClientController.subscribeToVideoTileControllerObservers(observer: videoTileController)
        videoClientController.start()
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
        videoClientController.unsubscribeFromVideoClientStateChange(observer: observer)
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

    public func startLocalVideo(source: VideoSource) {
        videoClientController.startLocalVideo(source: source)
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
