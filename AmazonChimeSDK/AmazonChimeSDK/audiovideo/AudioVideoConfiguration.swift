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

    // These convenience initializers exist so that Objective-C code can initialize this class without specifying all the parameters.
    convenience override public init() {
        self.init()
    }

    convenience public init(audioMode: AudioMode) {
        self.init(audioMode: audioMode)
    }

    convenience public init(audioDeviceCapabilities: AudioDeviceCapabilities) {
        self.init(audioDeviceCapabilities: audioDeviceCapabilities)
    }

    convenience public init(callKitEnabled: Bool) {
        self.init(callKitEnabled: callKitEnabled)
    }

    convenience public init(enableAudioRedundancy: Bool) {
        self.init(enableAudioRedundancy: enableAudioRedundancy)
    }

    convenience public init(videoMaxResolution: VideoResolution) {
        self.init(videoMaxResolution: videoMaxResolution)
    }

    convenience public init(audioMode: AudioMode, callKitEnabled: Bool) {
        self.init(audioMode: audioMode, callKitEnabled: callKitEnabled)
    }

    convenience public init(audioMode: AudioMode, callKitEnabled: Bool, enableAudioRedundancy: Bool) {
        self.init(audioMode: audioMode, callKitEnabled: callKitEnabled, enableAudioRedundancy: enableAudioRedundancy)
    }

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
