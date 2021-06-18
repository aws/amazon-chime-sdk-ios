//
//  DirtyMeetingEventItem.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

struct DirtyMeetingEventItem: Codable {
    let id: String
    let data: IngestionMeetingEvent
    let ttl: Int64

    init(id: String, data: IngestionMeetingEvent, ttl: Int64) {
        self.id = id
        self.data = data
        self.ttl = ttl
    }
}
