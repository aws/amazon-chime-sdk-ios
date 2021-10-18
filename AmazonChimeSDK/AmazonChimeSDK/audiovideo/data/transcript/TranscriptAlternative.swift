//
//  TranscriptAlternative.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// See [Using Amazon Chime SDK live transcription developer guide](https://docs.aws.amazon.com/chime/latest/dg/process-msgs.html) for more details about transcription message types and data guidelines
@objcMembers public class TranscriptAlternative: NSObject {
    public let items: [TranscriptItem]
    public let transcript: String

    public init(items: [TranscriptItem], transcript: String) {
        self.items = items
        self.transcript = transcript
    }
}
