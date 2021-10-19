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

    public init(audioMode: AudioMode = .mono, callKitEnabled: Bool = false) {
        self.audioMode = audioMode
        self.callKitEnabled = callKitEnabled
    }
}
