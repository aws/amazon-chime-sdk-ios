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
    var audioClient: AudioClientController
    var clientMetricsCollector: ClientMetricsCollector

    public init(configuration: MeetingSessionConfiguration, logger: Logger) {
        self.audioClient = AudioClientController.shared()
        self.clientMetricsCollector = ClientMetricsCollector.shared()
        self.configuration = configuration
        self.logger = logger
    }

    public func start() throws {
        let audioPermissionStatus = AVAudioSession.sharedInstance().recordPermission
        if audioPermissionStatus == .denied || audioPermissionStatus == .undetermined {
            throw PermissionError.audioPermissionError
        }

        audioClient.start(audioHostUrl: configuration.urls.audioHostURL,
                          meetingId: configuration.meetingId,
                          attendeeId: configuration.credentials.attendeeId,
                          joinToken: configuration.credentials.joinToken)
    }

    public func stop() {
        audioClient.stop()
    }

    public func addObserver(observer: AudioVideoObserver) {
        audioClient.addObserver(observer: observer)
        clientMetricsCollector.addObserver(observer: observer)
    }

    public func removeObserver(observer: AudioVideoObserver) {
        audioClient.removeObserver(observer: observer)
        clientMetricsCollector.removeObserver(observer: observer)
    }
}
