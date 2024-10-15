//
//  IngestionConfiguration.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `IngestionConfiguration` defines the configuration needed for ingestion service.
/// This will be passed down to `DefaultEventReporter`
@objcMembers public class IngestionConfiguration: NSObject {
    /// Event client configuration specific that has different properties based on type.
    /// For instance, meeting client configuration should have meetingId and attendeeId.
    public let clientConfiguration: EventClientConfiguration
    /// Url of ingestion endpoint to send data.
    public let ingestionUrl: String
    /// Whether ingestion is enabled or disabled.
    public let disabled: Bool
    /// Size to send to the server in a batch.
    /// Constraints:  >= 1 and <=100.
    public let flushSize: Int
    /// Interval to continously send to the server in a batch.
    /// Constraints: >= 300 ms.
    public let flushIntervalMs: Int64
    /// Number of retries.
    /// Constraints:  >= 1 and <= 3.
    public let retryCountLimit: Int

    init(clientConfiguration: EventClientConfiguration,
         ingestionUrl: String,
         disabled: Bool,
         flushSize: Int,
         flushIntervalMs: Int64,
         retryCountLimit: Int) {
        self.clientConfiguration = clientConfiguration
        self.ingestionUrl = ingestionUrl
        self.disabled = disabled
        self.flushSize = min(max(flushSize, 1), 100)
        self.flushIntervalMs = max(flushIntervalMs, 300)
        self.retryCountLimit = min(max(retryCountLimit, 1), 3)
    }
}
