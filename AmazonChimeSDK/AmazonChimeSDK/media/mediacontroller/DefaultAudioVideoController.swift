//
//  DefaultAudioVideoController.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

public class DefaultAudioVideoController: AudioVideoControllerFacade {

    public let configuration: MeetingSessionConfiguration
    public let logger: Logger

    private var audioClientController: AudioClientController
    private var videoClientController: VideoClientController
    private var videoTileController: VideoTileController

    public init(configuration: MeetingSessionConfiguration, logger: Logger, videoTileController: VideoTileController) {
        self.videoTileController = videoTileController
        let videoClientControllerParams = VideoClientController.InstanceParams(
            logger: logger,
            isUsing16by9AspectRatio: false,
            videoTileController: videoTileController) // TODO: Read from config
        VideoClientController.setup(params: videoClientControllerParams)
        self.videoClientController = VideoClientController.shared()
        self.audioClientController = AudioClientController.shared()
        self.configuration = configuration
        self.logger = logger
    }

    public func start() throws {
        try audioClientController.start(audioHostUrl: configuration.urls.audioHostURL,
                                        meetingId: configuration.meetingId,
                                        attendeeId: configuration.credentials.attendeeId,
                                        joinToken: configuration.credentials.joinToken)
        try videoClientController.start(turnControlUrl: configuration.urls.turnControlURL,
                                        signalingUrl: configuration.urls.signalingURL,
                                        meetingId: configuration.meetingId,
                                        joinToken: configuration.credentials.joinToken,
                                        sending: false)
    }

    public func stop() {
        audioClientController.stop()
        videoClientController.stopAndDestroy()
    }

    public func addObserver(observer: AudioVideoObserver) {
        audioClientController.addObserver(observer: observer)
    }

    public func removeObserver(observer: AudioVideoObserver) {
        audioClientController.removeObserver(observer: observer)
    }

    public func startLocalVideo() throws {
        try videoClientController.enableSelfVideo(isEnabled: true)
    }

    public func stopLocalVideo() {
        // TODO: it only throws error when isEnabled is true, so either refactor VideoClientController or change the signature to throws
        do {
            try videoClientController.enableSelfVideo(isEnabled: false)
        } catch {
            // NOP
        }
    }
}
