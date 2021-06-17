//
//  IngestionRecord.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `IngestionRecord` is the format of data that will be consumed on the ingestion server.
@objcMembers public class IngestionRecord: NSObject, Codable {
    /// Metadata associated with the event. This includes deviceName, OSVersion, and etc.
    public let metadata: IngestionMetadata
    /// List of `IngestionEvent`
    public let events: [IngestionEvent]

    public init(metadata: IngestionMetadata, events: [IngestionEvent]) {
        self.events = events
        self.metadata = metadata
    }
}
