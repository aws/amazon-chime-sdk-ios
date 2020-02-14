//
//  MeetingSessionURLs.swift
//  AmazonChimeSDK
//
//  Created by Wang, Haoran on 1/9/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
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
