//
//  MeetingSession.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

public protocol MeetingSession {
    var configuration: MeetingSessionConfiguration { get }
    var logger: Logger { get }
    var audioVideo: AudioVideoFacade { get }
}
