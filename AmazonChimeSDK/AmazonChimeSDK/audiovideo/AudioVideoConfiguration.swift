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
    public let audioDeviceCapabilities: AudioDeviceCapabilities
    public let callKitEnabled: Bool
    public let enableAudioRedundancy: Bool
    public let videoMaxResolution: VideoResolution

    public init(audioMode: AudioMode = .stereo48K,
                audioDeviceCapabilities: AudioDeviceCapabilities = .inputAndOutput,
                callKitEnabled: Bool = false,
                enableAudioRedundancy: Bool = true,
                videoMaxResolution: VideoResolution = .videoResolutionHD) {
        self.audioMode = audioMode
        self.audioDeviceCapabilities = audioDeviceCapabilities
        self.callKitEnabled = callKitEnabled
        self.enableAudioRedundancy = enableAudioRedundancy
        self.videoMaxResolution = videoMaxResolution
    }

    override public var description: String {
        return [
            "audioMode: \(self.audioMode.description)",
            "audioDeviceCapabilities: \(self.audioDeviceCapabilities.description)",
            "callKitEnabled: \(self.callKitEnabled)",
            "enableAudioRedundancy: \(self.enableAudioRedundancy)"
        ].joined(separator: ", ")
    }
}
