//
//  AudioVideoConfiguration.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `AudioVideoConfiguration` represents the configuration to be used for audio and video during a meeting session.
@objcMembers public class AudioVideoConfiguration: NSObject {
    public let audioMode: AudioMode
    public let callKitEnabled: Bool

    convenience override public init() {
        self.init(audioMode: .stereo48K, callKitEnabled: false)
    }

    convenience public init(audioMode: AudioMode) {
        self.init(audioMode: audioMode, callKitEnabled: false)
    }

    convenience public init(callKitEnabled: Bool) {
        self.init(audioMode: .stereo48K, callKitEnabled: callKitEnabled)
    }

    public init(audioMode: AudioMode, callKitEnabled: Bool) {
        self.audioMode = audioMode
        self.callKitEnabled = callKitEnabled
    }
}
