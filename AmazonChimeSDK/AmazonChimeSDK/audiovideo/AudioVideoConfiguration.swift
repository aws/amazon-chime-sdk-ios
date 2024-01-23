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
    public let enableAudioRedundancy: Bool
    public let videoMaxResolution: VideoResolution

    convenience override public init() {
        self.init(audioMode: .stereo48K, callKitEnabled: false, enableAudioRedundancy: true, videoMaxResolution: VideoResolution.videoResolutionHD)
    }

    convenience public init(audioMode: AudioMode) {
        self.init(audioMode: audioMode, callKitEnabled: false, enableAudioRedundancy: true, videoMaxResolution: VideoResolution.videoResolutionHD)
    }

    convenience public init(callKitEnabled: Bool) {
        self.init(audioMode: .stereo48K, callKitEnabled: callKitEnabled, enableAudioRedundancy: true, videoMaxResolution: VideoResolution.videoResolutionHD)
    }

    convenience public init(enableAudioRedundancy: Bool) {
         self.init(audioMode: .stereo48K, callKitEnabled: false, enableAudioRedundancy: enableAudioRedundancy, videoMaxResolution: VideoResolution.videoResolutionHD)
    }

    convenience public init(videoMaxResolution: VideoResolution) {
        self.init(audioMode: .stereo48K, callKitEnabled: false, enableAudioRedundancy: true, videoMaxResolution: videoMaxResolution)
    }

    convenience public init(audioMode: AudioMode, callKitEnabled: Bool) {
        self.init(audioMode: audioMode, callKitEnabled: callKitEnabled, enableAudioRedundancy: true, videoMaxResolution: VideoResolution.videoResolutionHD)
    }

    convenience public init(audioMode: AudioMode, callKitEnabled: Bool, enableAudioRedundancy: Bool) {
        self.init(audioMode: audioMode, callKitEnabled: callKitEnabled, enableAudioRedundancy: enableAudioRedundancy, videoMaxResolution: VideoResolution.videoResolutionHD)
    }

    public init(audioMode: AudioMode, callKitEnabled: Bool, enableAudioRedundancy: Bool, videoMaxResolution: VideoResolution) {
        self.audioMode = audioMode
        self.callKitEnabled = callKitEnabled
        self.enableAudioRedundancy = enableAudioRedundancy
        self.videoMaxResolution = videoMaxResolution
    }

    override public var description: String {
        return "audioMode: \(self.audioMode.description), callKitEnabled: \(self.callKitEnabled), enableAudioRedundancy: \(self.enableAudioRedundancy)"
    }
}
