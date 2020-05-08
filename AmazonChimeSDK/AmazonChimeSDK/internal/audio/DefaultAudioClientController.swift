//
//  DefaultAudioClientController.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDKMedia
import AVFoundation
import Foundation

class DefaultAudioClientController: NSObject {
    private let audioClient: AudioClient
    private let audioClientObserver: AudioClientObserver
    private let audioSession: AVAudioSession
    private let audioPortOffset = 200
    private static var audioClientState = AudioClientState.uninitialized
    private let defaultMicAndSpeaker = false
    private let defaultPort = 0
    private let defaultPresenter = true

    init(audioClient: AudioClient,
         audioClientObserver: AudioClientObserver,
         audioSession: AVAudioSession) {
        self.audioClient = audioClient
        self.audioClientObserver = audioClientObserver
        self.audioSession = audioSession

        if Self.audioClientState == .uninitialized {
            Self.audioClientState = .initialized
        }

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
                      joinToken: String) throws {
        guard audioSession.recordPermission == .granted else {
            throw PermissionError.audioPermissionError
        }

        switch Self.audioClientState {
        case .uninitialized:
            throw MediaError.audioUninitializedState
        case .started:
            throw MediaError.audioStartedState
        case .stopping:
            throw MediaError.audioStoppingState
        default:
            Self.audioClientState = .started
        }

        let url = audioHostUrl.components(separatedBy: ":")
        let host = url[0]
        let port = url.count >= 2 ? (url[1] as NSString).integerValue - audioPortOffset : defaultPort

        audioClientObserver.notifyAudioClientObserver { (observer: AudioVideoObserver) in
            observer.audioSessionDidStartConnecting(reconnecting: false)
        }

        audioClient.setSpeakerOn(true)
        audioClient.startSession(host,
                                 basePort: port,
                                 callId: meetingId,
                                 profileId: attendeeId,
                                 microphoneMute: defaultMicAndSpeaker,
                                 speakerMute: defaultMicAndSpeaker,
                                 isPresenter: defaultPresenter,
                                 sessionToken: joinToken,
                                 audioWsUrl: audioFallbackUrl)
    }

    public func stop() {
        Self.audioClientState = .stopping
        DispatchQueue.global().async {
            let audioClientStatusCode = self.audioClient.stopSession()
            Self.audioClientState = .stopped
            let meetingSessionStatusCode = Converters.AudioClientStatus.toMeetingSessionStatusCode(rawValue: UInt32(audioClientStatusCode))

            self.audioClientObserver.notifyAudioClientObserver { (observer: AudioVideoObserver) in
                observer.audioSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus(statusCode: meetingSessionStatusCode))
            }
        }
    }
}
