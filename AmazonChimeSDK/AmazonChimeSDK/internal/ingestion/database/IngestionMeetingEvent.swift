//
//  IngestionMeetingEvent.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// Internal meeting event to handle ingestion.
/// This will have string for key in the eventAttributes in order to make encode/decode easier
/// Swift doesn't decode Any type very well and it has to be one of pritimitve types.
struct IngestionMeetingEvent: Codable {
    let name: String
    var eventAttributes: [String: AnyCodable?]
}

// MARK: Helper methods for retriving data from `eventAttributes`
extension IngestionMeetingEvent {
    
    func getMeetingId() -> String? {
        let item = eventAttributes[EventAttributeName.meetingId.description]
        return item??.value as? String
    }
    
    func getTimestampMs() -> Int64? {
        let item = eventAttributes[EventAttributeName.timestampMs.description]
        return item??.int64Value
    }
    
    func getMaxVideoTileCount() -> Int? {
        let item = eventAttributes[EventAttributeName.maxVideoTileCount.description]
        return item??.value as? Int
    }
    
    func getMeetingStartDurationMs() -> Int64? {
        let item = eventAttributes[EventAttributeName.meetingStartDurationMs.description]
        return item??.int64Value
    }
    
    func getMeetingReconnectDurationMs() -> Int64? {
        let item = eventAttributes[EventAttributeName.meetingReconnectDurationMs.description]
        return item??.int64Value
    }
    
    func getMeetingDurationMs() -> Int64? {
        let item = eventAttributes[EventAttributeName.meetingDurationMs.description]
        return item??.int64Value
    }
    
    func getMeetingErrorMessage() -> String? {
        let item = eventAttributes[EventAttributeName.meetingErrorMessage.description]
        return item??.value as? String
    }
    
    func getMeetingStatus() -> String? {
        let item = eventAttributes[EventAttributeName.meetingStatus.description]
        return item??.value as? String
    }
    
    func getPoorConnectionCount() -> Int? {
        let item = eventAttributes[EventAttributeName.poorConnectionCount.description]
        return item??.value as? Int
    }
    
    func getRetryCount() -> Int? {
        let item = eventAttributes[EventAttributeName.retryCount.description]
        return item??.value as? Int
    }
    
    func getVideoInputErrorMessage() -> String? {
        let item = eventAttributes[EventAttributeName.videoInputError.description]
        return item??.value as? String
    }
    
    func getAudioInputErrorMessage() -> String? {
        let item = eventAttributes[EventAttributeName.audioInputError.description]
        return item??.value as? String
    }
}
