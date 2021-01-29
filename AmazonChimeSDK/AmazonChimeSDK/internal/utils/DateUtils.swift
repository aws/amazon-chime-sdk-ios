//
//  DateUtils.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

class DateUtils {
    static func getCurrentTimeStampMs() -> Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}
