//
//  MeetingSession.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objc public protocol MeetingSession {
    var configuration: MeetingSessionConfiguration { get }
    var logger: Logger { get }
    var audioVideo: AudioVideoFacade { get }
}
