//
//  LogEntry.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AmazonChimeSDK

struct LogEntry: Codable {
    var sequenceNumber: Int
    var message: String
    var timestampMs: Int64
    var logLevel: String
}
