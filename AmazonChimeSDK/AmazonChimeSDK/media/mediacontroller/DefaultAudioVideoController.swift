//
//  DefaultAudioVideoController.swift
//  AmazonChimeSDK
//
//  Created by Xu, Tianyu on 1/12/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

import Foundation
import AudioClient

public class DefaultAudioVideoController: AudioVideoControllerFacade {
    public let configuration: MeetingSessionConfiguration
    public let logger: Logger
    var audioClient: AudioClientController

    public init(configuration: MeetingSessionConfiguration, logger: Logger) {
        self.audioClient = AudioClientController.shared()
        self.configuration = configuration
        self.logger = logger
    }

    public func start() {
        audioClient.start(audioHostUrl: configuration.urls.audioHostURL,
                          meetingId: configuration.meetingId,
                          attendeeId: configuration.credentials.attendeeId,
                          joinToken: configuration.credentials.joinToken)

    }

    public func stop() {
        audioClient.stop()
    }
}
