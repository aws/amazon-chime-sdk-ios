//
//  LogLevel.swift
//  AmazonChimeSDK
//
//  Created by Wang, Haoran on 1/9/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
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
