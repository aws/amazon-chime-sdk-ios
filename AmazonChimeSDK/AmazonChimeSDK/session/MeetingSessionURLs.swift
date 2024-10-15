//
//  MeetingSessionURLs.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `MeetingSessionURLs` contains the URLs that will be used to reach the meeting service.
@objcMembers public class MeetingSessionURLs: NSObject, Codable {
    /// The audio fallback URL of the session
    public let audioFallbackUrl: String

    /// The audio host URL of the session
    public let audioHostUrl: String

    /// The TURN control URL of the session
    public let turnControlUrl: String

    /// The signaling URL of the session
    public let signalingUrl: String

    /// The event ingestion URL of the session
    public let ingestionUrl: String?

    public convenience init(audioFallbackUrl: String,
                            audioHostUrl: String,
                            turnControlUrl: String,
                            signalingUrl: String,
                            urlRewriter: URLRewriter) {
        self.init(audioFallbackUrl: audioFallbackUrl,
                  audioHostUrl: audioHostUrl,
                  turnControlUrl: turnControlUrl,
                  signalingUrl: signalingUrl,
                  urlRewriter: urlRewriter,
                  ingestionUrl: nil)
    }

    public init(audioFallbackUrl: String,
                audioHostUrl: String,
                turnControlUrl: String,
                signalingUrl: String,
                urlRewriter: URLRewriter,
                ingestionUrl: String?) {
        self.audioFallbackUrl = urlRewriter(audioFallbackUrl)
        self.audioHostUrl = urlRewriter(audioHostUrl)
        self.turnControlUrl = urlRewriter(turnControlUrl)
        self.signalingUrl = urlRewriter(signalingUrl)
        if let ingestionUrl = ingestionUrl {
            self.ingestionUrl = urlRewriter(ingestionUrl)
        } else {
            self.ingestionUrl = ingestionUrl
        }
    }
}
