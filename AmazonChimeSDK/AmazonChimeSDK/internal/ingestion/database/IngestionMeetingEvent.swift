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
    let eventAttributes: IngestionEventAttributes
}
