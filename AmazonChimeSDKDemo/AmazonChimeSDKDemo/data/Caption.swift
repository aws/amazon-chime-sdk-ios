//
//  Caption.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import Foundation

public class Caption {
    let speakerName: String
    var isPartial: Bool
    var content: String
    var entities: [String]?
    var items: [TranscriptItem]?

    init(speakerName: String, isPartial: Bool, content: String, entities: [String]? = nil, items: [TranscriptItem]? = nil) {
        self.speakerName = speakerName
        self.isPartial = isPartial
        self.content = content
        self.entities = entities
        self.items = items
    }
}
