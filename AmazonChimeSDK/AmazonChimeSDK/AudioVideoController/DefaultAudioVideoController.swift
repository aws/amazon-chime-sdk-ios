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
    
    public var configuration: MeetingSessionConfiguration
    public var logger: Logger
    var audioClient: AudioClient

    public init(configuration: MeetingSessionConfiguration, logger: Logger) {
        self.audioClient = AudioClient()
        self.configuration = configuration
        self.logger = logger
    }

    public func start() {
        // TODO
        let url = configuration.urls.audioHostURL.components(separatedBy: ":")
        let host = url[0]
        var port = 0

        if url.count >= 2 {
            port = (url[1] as NSString).integerValue - 200
        }
        
        audioClient.startSession(AUDIO_CLIENT_TRANSPORT_DTLS,
                                              host: host,
                                              basePort: port,
                                              proxyCallback: nil,
                                              callId: configuration.meetingId,
                                              profileId: configuration.credentials.attendeeId,
                                              microphoneCodec: codec_mode_t(rawValue: 6),
                                              speakerCodec: codec_mode_t(rawValue: 6),
                                              microphoneMute: false,
                                              speakerMute: false,
                                              isPresenter: true,
                                              features: nil,
                                              sessionToken: configuration.credentials.joinToken,
                                              audioWsUrl: "",
                                              callKitEnabled: true)
        
    }

    public func stop() {
        // TODO
    }
}
