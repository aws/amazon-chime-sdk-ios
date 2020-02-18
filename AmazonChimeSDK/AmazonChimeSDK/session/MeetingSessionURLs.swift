//
//  MeetingSessionURLs.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

public struct MeetingSessionURLs {
    public let audioHostURL: String
    public let turnControlURL: String
    public let signalingURL: String

    public init(audioHostURL: String, turnControlURL: String, signalingURL: String) {
        self.audioHostURL = audioHostURL
        self.turnControlURL = turnControlURL
        self.signalingURL = signalingURL
    }
}
