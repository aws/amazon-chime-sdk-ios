//
//  MeetingSessionURLs.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `MeetingSessionURLs` contains the URLs that will be used to reach the meeting service.
@objcMembers public class MeetingSessionURLs: NSObject {
    /// The audio fallback URL of the session
    public let audioFallbackUrl: String

    /// The audio host URL of the session
    public let audioHostUrl: String

    /// The TURN control URL of the session
    public let turnControlUrl: String

    /// The signaling URL of the session
    public let signalingUrl: String

    public init(audioFallbackUrl: String,
                audioHostUrl: String,
                turnControlUrl: String,
                signalingUrl: String) {
        self.audioFallbackUrl = audioFallbackUrl
        self.audioHostUrl = audioHostUrl
        self.turnControlUrl = turnControlUrl
        self.signalingUrl = signalingUrl
    }
}
