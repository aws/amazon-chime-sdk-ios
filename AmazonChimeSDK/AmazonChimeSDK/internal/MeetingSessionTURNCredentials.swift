//
//  MeetingSessionTURNCredentials.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

struct MeetingSessionTURNCredentials: Codable {
    let username: String
    let password: String
    let ttl: Int
    let uris: [String]
}
