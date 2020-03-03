//
//  LogLevel.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
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
