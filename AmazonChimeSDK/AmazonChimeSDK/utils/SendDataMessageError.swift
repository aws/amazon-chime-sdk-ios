//
//  SendDataMessageError.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objc public enum SendDataMessageError: Int, Error, CustomStringConvertible {
    // Data message payload is too large
    case invalidDataLength

    // Topic string is not passing regex check
    case invalidTopic

    // Lifetime parameter should be positive
    case negativeLifetimeParameter

    // Data can only be string or JSON serializable (JSONSerialization.isValidJSONObject() == true)
    case invalidData

    public var description: String {
        switch self {
        case .invalidDataLength:
            return "invalidDataLength"
        case .invalidTopic:
            return "invalidTopic"
        case .negativeLifetimeParameter:
            return "negativeLifetimeParameter"
        case .invalidData:
            return "invalidData"
        }
    }
}
