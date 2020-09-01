//
//  AudioClientInterface.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDKMedia
import Foundation

@objc public protocol AudioClientProtocol {
    func startSession(_ host: String!, basePort port: Int, callId: String!, profileId: String!, microphoneMute mic_mute: Bool, speakerMute spk_mute: Bool, isPresenter presenter: Bool, sessionToken tokenString: String!, audioWsUrl: String!, callKitEnabled: Bool) -> audio_client_status_t

    func stopSession() -> Int

    func isSpeakerOn() -> Bool

    func setSpeakerOn(_ value: Bool) -> Bool

    func stopAudioRecord() -> Int

    func isMicrophoneMuted() -> Bool

    func setMicrophoneMuted(_ mute: Bool) -> Int

    func setPresenter(_ presenter: Bool)

    func remoteMute()

    func audioLogCallBack(_ logLevel: loglevel_t, msg: String!)
}

extension AudioClient: AudioClientProtocol {}
