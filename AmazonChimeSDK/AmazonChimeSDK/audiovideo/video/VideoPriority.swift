//
//  VideoPriority.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// Enum defining video priority for remote video sources. The 'higher' the number the 'higher' the priority for the source when adjusting video quality
/// to adapt to variable network conditions, i.e. `highest` will be chosen before `high`, `medium`, etc.
@objc public enum VideoPriority: Int {
    case lowest = 0
    case low = 10
    case medium = 20
    case high = 30
    case highest = 40
}
