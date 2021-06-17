//
//  IngestionEvent.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// Event data that will be send to the ingestion server
@objcMembers public class IngestionEvent: NSObject, Codable {
    /// Event Client Type associated with this event
    public let type: String
    /// metadata that could be overriden
    public let metadata: IngestionMetadata
    /// Payload associated with this ingestion event.
    public let payloads: [IngestionPayload]
    /// Version of payload. Different event format could give different version.
    public let version: Int
    public convenience init(type: String, metadata: IngestionMetadata, payloads: [IngestionPayload]) {
        self.init(type: type, metadata: metadata, payloads: payloads, version: 1)
    }

    public init(type: String, metadata: IngestionMetadata, payloads: [IngestionPayload], version: Int) {
        self.type = type
        self.metadata = metadata
        self.payloads = payloads
        self.version = version
    }

    enum CodingKeys: String, CodingKey {
        case version = "v"
        case type
        case metadata
        case payloads
    }
}
