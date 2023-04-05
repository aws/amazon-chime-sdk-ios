//
//  TimezoneUtils.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

class TimezoneUtils {
    private static let utcOffsetFormat = "%@%.2d:%.2d"

    public class func getClientUtcOffset(offsetSeconds: Int) -> String {
        let offsetHours = abs(offsetSeconds / 60) / 60
        let offsetMinutes = abs(offsetSeconds / 60) % 60
        let offsetSign = offsetSeconds < 0 ? "-" : "+"
        let offset = String(format: utcOffsetFormat, offsetSign, offsetHours, offsetMinutes)
        return offset
   }
}
