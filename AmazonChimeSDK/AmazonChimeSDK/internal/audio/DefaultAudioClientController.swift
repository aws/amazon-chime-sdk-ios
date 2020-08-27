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
    static var state = AudioClientState.initialized
    private let audioLock: AudioLock
    private var audioClient: AudioClientProtocol
    private let audioClientObserver: AudioClientObserver
    private let audioSession: AudioSession
    private let audioPortOffset = 200
    private let defaultMicAndSpeaker = false
    private let defaultPort = 0
    private let defaultPresenter = true

    init(audioClient: AudioClientProtocol,
         audioClientObserver: AudioClientObserver,
         audioSession: AudioSession,
         audioClientLock: AudioLock)
    {
        self.audioClient = audioClient
        self.audioClientObserver = audioClientObserver
        self.audioSession = audioSession
        audioLock = audioClientLock

        super.init()
    }
}

extension DefaultAudioClientController: AudioClientController {
    public func setMute(mute: Bool) -> Bool {
        if Self.state == .started {
            return audioClient.setMicrophoneMuted(mute) == Int(AUDIO_CLIENT_OK.rawValue)
        } else {
            return false
        }
    }

    public func start(audioFallbackUrl: String,
                      audioHostUrl: String,
                      meetingId: String,
                      attendeeId: String,
                      joinToken: String,
                      callKitEnabled: Bool) throws
    {
        audioLock.lock()
        defer {
            audioLock.unlock()
        }
        guard audioSession.recordPermission == .granted else {
            throw PermissionError.audioPermissionError
        }

        if Self.state == .started {
            throw MediaError.illegalState
        }

        let url = audioHostUrl.components(separatedBy: ":")
        let host = url[0]
        let port = url.count >= 2 ? (url[1] as NSString).integerValue - audioPortOffset : defaultPort

        audioClientObserver.notifyAudioClientObserver { (observer: AudioVideoObserver) in
            observer.audioSessionDidStartConnecting(reconnecting: false)
        }

        let status = audioClient.startSession(host,
                                              basePort: port,
                                              callId: meetingId,
                                              profileId: attendeeId,
                                              microphoneMute: defaultMicAndSpeaker,
                                              speakerMute: defaultMicAndSpeaker,
                                              isPresenter: defaultPresenter,
                                              sessionToken: joinToken,
                                              audioWsUrl: audioFallbackUrl,
                                              callKitEnabled: callKitEnabled)
        if status == AUDIO_CLIENT_OK {
            Self.state = .started
        } else {
            throw MediaError.audioFailedToStart
        }
    }

    public func stop() {
        if Self.state != .started {
            return
        }

        DispatchQueue.global().async {
            self.audioLock.lock()
            let audioClientStatusCode = self.audioClient.stopSession()
            Self.state = .stopped
            let meetingSessionStatusCode = Converters.AudioClientStatus.toMeetingSessionStatusCode(
                rawValue: UInt32(audioClientStatusCode)
            )
            self.audioLock.unlock()
            self.audioClientObserver.notifyAudioClientObserver { (observer: AudioVideoObserver) in
                observer.audioSessionDidStopWithStatus(
                    sessionStatus: MeetingSessionStatus(statusCode: meetingSessionStatusCode)
                )
            }
        }
    }
}
