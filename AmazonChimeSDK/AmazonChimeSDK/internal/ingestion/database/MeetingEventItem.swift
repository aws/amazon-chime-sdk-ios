//
//  MeetingEventItem.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

struct MeetingEventItem: Codable {
    let id: String
    let data: IngestionMeetingEvent

    init(id: String, data: IngestionMeetingEvent) {
        self.id = id
        self.data = data
    }
}
