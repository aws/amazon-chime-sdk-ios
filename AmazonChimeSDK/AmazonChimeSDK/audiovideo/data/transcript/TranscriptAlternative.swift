//
//  TranscriptAlternative.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers public class TranscriptAlternative: NSObject {
    public let items: [TranscriptItem]
    public let transcript: String

    public init(items: [TranscriptItem], transcript: String) {
        self.items = items
        self.transcript = transcript
    }
}
