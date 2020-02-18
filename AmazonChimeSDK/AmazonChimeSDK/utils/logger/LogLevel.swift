//
//  LogLevel.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

public enum LogLevel: Int, CaseIterable {
    case DEFAULT = 0
    case DEBUG = 1
    case INFO = 2
    case FAULT = 3
    case ERROR = 4
    case OFF = 5
}
