//
//  EventClientConfiguration.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `EventClientType` defines type of `EventClientConfiguration`
@objc public enum EventClientType: Int, CaseIterable, CustomStringConvertible {
    case meet
    case chat

    public var description: String {
        switch self {
        case .meet:
            return "Meet"
        case .chat:
            return "Chat"
        }
    }
}

/// `EventClientConfiguration` contains speciic data required to send as metadata.
@objc public protocol EventClientConfiguration {
    
    /**
     The type of the Ingestion event
     - Attention: replaced with `tag`
     */
    var type: EventClientType { get }
    var eventClientJoinToken: String { get }
    
    /**
     Tagging the source of the events, which will be translated to `Type` for Ingestion event
     */
    var tag: String { get }
    
    /**
     The attributes that will be sent to Ingestion Service as metadata along with common attributes
     */
    var metadataAttributes: [String: Any] { get }
}
