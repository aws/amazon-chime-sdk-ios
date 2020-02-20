//
//  DefaultAudioVideoController.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import AVFoundation
import Foundation

public class DefaultAudioVideoController: AudioVideoControllerFacade {
    public let configuration: MeetingSessionConfiguration
    public let logger: Logger

    private let audioClientController: AudioClientController
    private let audioClientObserver: AudioClientObserver
    private let clientMetricsCollector: ClientMetricsCollector

    public init(audioClientController: AudioClientController,
                audioClientObserver: AudioClientObserver,
                clientMetricsCollector: ClientMetricsCollector,
                configuration: MeetingSessionConfiguration,
                logger: Logger) {
        self.audioClientController = audioClientController
        self.audioClientObserver = audioClientObserver
        self.clientMetricsCollector = clientMetricsCollector
        self.configuration = configuration
        self.logger = logger
    }

    public func start() throws {
        let audioPermissionStatus = AVAudioSession.sharedInstance().recordPermission
        if audioPermissionStatus == .denied || audioPermissionStatus == .undetermined {
            throw PermissionError.audioPermissionError
        }

        audioClientController.start(audioFallbackUrl: configuration.urls.audioFallbackUrl,
                                    audioHostUrl: configuration.urls.audioHostUrl,
                                    meetingId: configuration.meetingId,
                                    attendeeId: configuration.credentials.attendeeId,
                                    joinToken: configuration.credentials.joinToken)
    }

    public func stop() {
        audioClientController.stop()
    }

    public func addObserver(observer: AudioVideoObserver) {
        audioClientObserver.subscribeToAudioClientStateChange(observer: observer)
        clientMetricsCollector.subscribeToClientStateChange(observer: observer)
    }

    public func removeObserver(observer: AudioVideoObserver) {
        audioClientObserver.unsubscribeFromAudioClientStateChange(observer: observer)
        clientMetricsCollector.unsubscribeFromClientStateChange(observer: observer)
    }
}
