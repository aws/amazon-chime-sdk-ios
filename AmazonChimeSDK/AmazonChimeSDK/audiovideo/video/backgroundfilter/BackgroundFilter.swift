//
//  BackgroundFilter.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// Enum defining the different background filter options.
@objc public enum BackgroundFilter: Int {
    case none
    case blur
    case replacement

    public var description: String {
        switch self {
        case .none:
            return "none"
        case .blur:
            return "blur"
        case .replacement:
            return "replacement"
        }
    }
}
