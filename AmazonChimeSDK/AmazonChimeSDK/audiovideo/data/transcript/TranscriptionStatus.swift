//
//  TranscriptionStatus.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers public class TranscriptionStatus: NSObject, TranscriptEvent {
    public let type: TranscriptionStatusType
    public let eventTimeMs: Int64
    public let transcriptionRegion: String
    public let transcriptionConfiguration: String
    public let message: String?

    public init(type: TranscriptionStatusType,
                eventTimeMs: Int64,
                transcriptionRegion: String,
                transcriptionConfiguration: String,
                message: String?) {
        self.type = type
        self.eventTimeMs = eventTimeMs
        self.transcriptionRegion = transcriptionRegion
        self.transcriptionConfiguration = transcriptionConfiguration
        self.message = message
    }
}
