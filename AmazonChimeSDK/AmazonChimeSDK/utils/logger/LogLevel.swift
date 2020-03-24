//
//  LogLevel.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objc public enum LogLevel: Int, CaseIterable, CustomStringConvertible {
    case DEFAULT = 0
    case DEBUG = 1
    case INFO = 2
    case FAULT = 3
    case ERROR = 4
    case OFF = 5

    public var description: String {
        switch self {
        case .DEFAULT:
            return "DEFAULT"
        case .DEBUG:
            return "DEBUG"
        case .INFO:
            return "INFO"
        case .FAULT:
            return "FAULT"
        case .ERROR:
            return "ERROR"
        case .OFF:
            return "OFF"
        }
    }
}
