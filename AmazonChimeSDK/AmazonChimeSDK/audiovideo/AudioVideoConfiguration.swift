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
    public static let defaultAudioMode: AudioMode = .stereo48K
    public static let defaultAudioDeviceCapabilities: AudioDeviceCapabilities = .inputAndOutput
    public static let defaultCallKitEnabled: Bool = false
    public static let defaultEnableAudioRedundancy: Bool = true
    public static let defaultVideoMaxResolution: VideoResolution = .videoResolutionHD
    public static let defaultReconnectTimeoutMs: Int = 180 * 1000

    public let audioMode: AudioMode
    public let audioDeviceCapabilities: AudioDeviceCapabilities
    public let callKitEnabled: Bool
    public let enableAudioRedundancy: Bool
    public let videoMaxResolution: VideoResolution
    /// Maximum amount of time in milliseconds to allow for reconnecting. Default value is 180000.
    public let reconnectTimeoutMs: Int

    // These convenience initializers exist so that Objective-C code can initialize this class without specifying all the parameters.
    convenience override public init() {
        self.init(audioMode: Self.defaultAudioMode,
                  audioDeviceCapabilities: Self.defaultAudioDeviceCapabilities,
                  callKitEnabled: Self.defaultCallKitEnabled,
                  enableAudioRedundancy: Self.defaultEnableAudioRedundancy,
                  videoMaxResolution: Self.defaultVideoMaxResolution)
    }

    convenience public init(audioMode: AudioMode) {
        self.init(audioMode: audioMode,
                  audioDeviceCapabilities: Self.defaultAudioDeviceCapabilities,
                  callKitEnabled: Self.defaultCallKitEnabled,
                  enableAudioRedundancy: Self.defaultEnableAudioRedundancy,
                  videoMaxResolution: Self.defaultVideoMaxResolution)
    }

    convenience public init(audioDeviceCapabilities: AudioDeviceCapabilities) {
        self.init(audioMode: Self.defaultAudioMode,
                  audioDeviceCapabilities: audioDeviceCapabilities,
                  callKitEnabled: Self.defaultCallKitEnabled,
                  enableAudioRedundancy: Self.defaultEnableAudioRedundancy,
                  videoMaxResolution: Self.defaultVideoMaxResolution)
    }

    convenience public init(callKitEnabled: Bool) {
        self.init(audioMode: Self.defaultAudioMode,
                  audioDeviceCapabilities: Self.defaultAudioDeviceCapabilities,
                  callKitEnabled: callKitEnabled,
                  enableAudioRedundancy: Self.defaultEnableAudioRedundancy,
                  videoMaxResolution: Self.defaultVideoMaxResolution)
    }

    convenience public init(enableAudioRedundancy: Bool) {
        self.init(audioMode: Self.defaultAudioMode,
                  audioDeviceCapabilities: Self.defaultAudioDeviceCapabilities,
                  callKitEnabled: Self.defaultCallKitEnabled,
                  enableAudioRedundancy: enableAudioRedundancy,
                  videoMaxResolution: Self.defaultVideoMaxResolution)
    }

    convenience public init(videoMaxResolution: VideoResolution) {
        self.init(audioMode: Self.defaultAudioMode,
                  audioDeviceCapabilities: Self.defaultAudioDeviceCapabilities,
                  callKitEnabled: Self.defaultCallKitEnabled,
                  enableAudioRedundancy: Self.defaultEnableAudioRedundancy,
                  videoMaxResolution: videoMaxResolution)
    }
    
    convenience public init(reconnectTimeoutMs: Int) {
        self.init(audioMode: Self.defaultAudioMode,
                  audioDeviceCapabilities: Self.defaultAudioDeviceCapabilities,
                  callKitEnabled: Self.defaultCallKitEnabled,
                  enableAudioRedundancy: Self.defaultEnableAudioRedundancy,
                  videoMaxResolution: Self.defaultVideoMaxResolution,
                  reconnectTimeoutMs: reconnectTimeoutMs)
    }

    convenience public init(audioMode: AudioMode, callKitEnabled: Bool) {
        self.init(audioMode: audioMode,
                  audioDeviceCapabilities: Self.defaultAudioDeviceCapabilities,
                  callKitEnabled: callKitEnabled,
                  enableAudioRedundancy: Self.defaultEnableAudioRedundancy,
                  videoMaxResolution: Self.defaultVideoMaxResolution)
    }

    convenience public init(audioMode: AudioMode, callKitEnabled: Bool, enableAudioRedundancy: Bool) {
        self.init(audioMode: audioMode,
                  audioDeviceCapabilities: Self.defaultAudioDeviceCapabilities,
                  callKitEnabled: callKitEnabled,
                  enableAudioRedundancy: enableAudioRedundancy,
                  videoMaxResolution: Self.defaultVideoMaxResolution)
    }
    
    convenience public init(audioMode: AudioMode, callKitEnabled: Bool, enableAudioRedundancy: Bool, videoMaxResolution: VideoResolution) {
        self.init(audioMode: audioMode,
                  audioDeviceCapabilities: Self.defaultAudioDeviceCapabilities,
                  callKitEnabled: callKitEnabled,
                  enableAudioRedundancy: enableAudioRedundancy,
                  videoMaxResolution: videoMaxResolution)
    }

    convenience public init(audioMode: AudioMode, audioDeviceCapabilities: AudioDeviceCapabilities, callKitEnabled: Bool, enableAudioRedundancy: Bool, videoMaxResolution: VideoResolution) {
        
        self.init(audioMode: audioMode,
                  audioDeviceCapabilities: audioDeviceCapabilities,
                  callKitEnabled: callKitEnabled,
                  enableAudioRedundancy: enableAudioRedundancy,
                  videoMaxResolution: videoMaxResolution,
                  reconnectTimeoutMs: Self.defaultReconnectTimeoutMs)
    }
    
    public init(audioMode: AudioMode, audioDeviceCapabilities: AudioDeviceCapabilities, callKitEnabled: Bool, enableAudioRedundancy: Bool, videoMaxResolution: VideoResolution, reconnectTimeoutMs: Int) {
        self.audioMode = audioMode
        self.audioDeviceCapabilities = audioDeviceCapabilities
        self.callKitEnabled = callKitEnabled
        self.enableAudioRedundancy = enableAudioRedundancy
        self.videoMaxResolution = videoMaxResolution
        self.reconnectTimeoutMs = reconnectTimeoutMs
    }

    override public var description: String {
        return [
            "audioMode: \(self.audioMode.description)",
            "audioDeviceCapabilities: \(self.audioDeviceCapabilities.description)",
            "callKitEnabled: \(self.callKitEnabled)",
            "enableAudioRedundancy: \(self.enableAudioRedundancy)",
            "videoMaxResolution: \(self.videoMaxResolution.description)",
            "reconnectTimeoutMs: \(self.reconnectTimeoutMs.description)",
        ].joined(separator: ", ")
    }
}
