//
//  RequestBody.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

struct LogRequestBody: Codable {
    var meetingId: String
    var attendeeId: String
    var appName: String
    var logs: [LogEntry]
}
