//
//  MeetingSessionTURNCredentials.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

struct MeetingSessionTURNCredentials: Codable {
    let username: String
    let password: String
    let ttl: Int
    let uris: [String]
}
