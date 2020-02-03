//
//  DefaultAudioVideoController.swift
//  AmazonChimeSDK
//
//  Created by Xu, Tianyu on 1/12/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

import Foundation
import AVFoundation

public class DefaultAudioVideoController: AudioVideoControllerFacade {
    public let configuration: MeetingSessionConfiguration
    public let logger: Logger
    var audioClient: AudioClientController

    public init(configuration: MeetingSessionConfiguration, logger: Logger) {
        self.audioClient = AudioClientController.shared()
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
    }

    public func removeObserver(observer: AudioVideoObserver) {
        audioClient.removeObserver(observer: observer)
    }
}
