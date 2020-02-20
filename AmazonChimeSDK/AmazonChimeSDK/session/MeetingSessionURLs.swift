//
//  MeetingSessionURLs.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

public struct MeetingSessionURLs {
    public let audioFallbackUrl: String
    public let audioHostUrl: String

    public init(audioFallbackUrl: String,
                audioHostUrl: String) {
        self.audioFallbackUrl = audioFallbackUrl
        self.audioHostUrl = audioHostUrl
    }
}
