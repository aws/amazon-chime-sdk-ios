//
//  IngestionPayload.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers public class IngestionPayload: NSObject, Codable {
    public let name: String
    public let ts: Int64
    public let id: String?
    public let maxVideoTileCount: Int?
    public let meetingStartDurationMs: Int64?
    public let meetingDurationMs: Int64?
    public let meetingErrorMessage: String?
    public let meetingStatus: String?
    public let poorConnectionCount: Int?
    public let retryCount: Int?
    public let videoInputErrorMessage: String?
    public let ttl: Int64?

    public init(name: String,
                ts: Int64,
                id: String? = nil,
                maxVideoTileCount: Int? = nil,
                meetingStartDurationMs: Int64? = nil,
                meetingDurationMs: Int64? = nil,
                meetingErrorMessage: String? = nil,
                meetingStatus: String? = nil,
                poorConnectionCount: Int? = nil,
                retryCount: Int? = nil,
                videoInputErrorMessage: String? = nil,
                ttl: Int64? = nil) {
        self.name = name
        self.ts = ts
        self.id = id
        self.maxVideoTileCount = maxVideoTileCount
        self.meetingStartDurationMs = meetingStartDurationMs
        self.meetingDurationMs = meetingDurationMs
        self.meetingErrorMessage = meetingErrorMessage
        self.meetingStatus = meetingStatus
        self.poorConnectionCount = poorConnectionCount
        self.retryCount = retryCount
        self.videoInputErrorMessage = videoInputErrorMessage
        self.ttl = ttl
    }
}
