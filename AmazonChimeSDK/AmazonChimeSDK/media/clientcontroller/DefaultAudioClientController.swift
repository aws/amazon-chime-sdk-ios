//
//  DefaultAudioClientController.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

class DefaultAudioClientController: NSObject {
    private let audioClient: AudioClient
    private let audioClientObserver: AudioClientObserver
    private let audioPortOffset: Int
    private let defaultMicAndSpeaker: Bool
    private let defaultPort: Int
    private let defaultPresenter: Bool

    init(audioClient: AudioClient,
         audioClientObserver: AudioClientObserver) {
        audioPortOffset = 200
        defaultMicAndSpeaker = false
        defaultPort = 0
        defaultPresenter = true

        self.audioClient = audioClient
        self.audioClientObserver = audioClientObserver

        super.init()
    }
}

extension DefaultAudioClientController: AudioClientController {
    public func setMute(mute: Bool) -> Bool {
        return audioClient.setMicrophoneMuted(mute) == Int(AUDIO_CLIENT_OK.rawValue)
    }

    public func start(audioFallbackUrl: String,
                      audioHostUrl: String,
                      meetingId: String,
                      attendeeId: String,
                      joinToken: String) {
        let url = audioHostUrl.components(separatedBy: ":")
        let host = url[0]
        let port = url.count >= 2 ? (url[1] as NSString).integerValue - audioPortOffset : defaultPort

        audioClientObserver.notifyAudioClientObserver { (observer: AudioVideoObserver) in
            observer.onAudioVideoStartConnecting(reconnecting: false)
        }

        audioClient.setSpeakerOn(true)
        audioClient.startSession(AUDIO_CLIENT_TRANSPORT_DTLS,
                                 host: host,
                                 basePort: port,
                                 proxyCallback: nil,
                                 callId: meetingId,
                                 profileId: attendeeId,
                                 microphoneCodec: kCodecOpusLow,
                                 speakerCodec: kCodecOpusLow,
                                 microphoneMute: defaultMicAndSpeaker,
                                 speakerMute: defaultMicAndSpeaker,
                                 isPresenter: defaultPresenter,
                                 features: nil,
                                 sessionToken: joinToken,
                                 audioWsUrl: audioFallbackUrl,
                                 khiEnabled: true,
                                 callKitEnabled: true)
    }

    public func stop() {
        audioClient.stopSession()
    }
}
