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
    case none = 0
    case blur = 1
    case replacement = 2
}
