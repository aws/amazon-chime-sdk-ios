//
//  Transcript.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers public class Transcript: NSObject, TranscriptEvent {
    public let results: [TranscriptResult]

    public init(results: [TranscriptResult]) {
        self.results = results
    }
}
