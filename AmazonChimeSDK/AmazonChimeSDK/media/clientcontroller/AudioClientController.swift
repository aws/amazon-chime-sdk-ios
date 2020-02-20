//
//  AudioClientController.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

public protocol AudioClientController {
    func setMute(mute: Bool) -> Bool
    func start(audioHostUrl: String, meetingId: String, attendeeId: String, joinToken: String) throws
    func stop()
}
