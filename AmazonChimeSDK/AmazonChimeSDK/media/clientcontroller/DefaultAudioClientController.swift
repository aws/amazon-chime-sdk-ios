//
//  DefaultAudioClientController.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import AVFoundation
import Foundation

class DefaultAudioClientController: NSObject {
    private let audioClient: AudioClient
    private let audioClientObserver: AudioClientObserver
    private let audioSession: AVAudioSession
    private let audioPortOffset: Int
    private let defaultMicAndSpeaker: Bool
    private let defaultPresenter: Bool

    init(audioClient: AudioClient,
         audioClientObserver: AudioClientObserver,
         audioSession: AVAudioSession) {
        audioPortOffset = 200
        defaultMicAndSpeaker = false
        defaultPresenter = true

        self.audioClient = audioClient
        self.audioClientObserver = audioClientObserver
        self.audioSession = audioSession

        super.init()
    }
}

extension DefaultAudioClientController: AudioClientController {
    public func setMute(mute: Bool) -> Bool {
        return audioClient.setMicrophoneMuted(mute) == Int(AUDIO_CLIENT_OK.rawValue)
    }

    public func start(audioHostUrl: String,
                      meetingId: String,
                      attendeeId: String,
                      joinToken: String) throws {
        guard audioSession.recordPermission == .granted else {
            throw PermissionError.audioPermissionError
        }

        let url = audioHostUrl.components(separatedBy: ":")
        let host = url[0]
        var port = 0

        if url.count >= 2 {
            port = (url[1] as NSString).integerValue - audioPortOffset
        }

        audioClientObserver.notifyAudioClientObserver { (observer: AudioVideoObserver) in
            observer.onAudioClientConnecting(reconnecting: false)
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
                                 audioWsUrl: "",
                                 khiEnabled: true,
                                 callKitEnabled: true)
    }

    public func stop() {
        audioClient.stopSession()
    }
}
