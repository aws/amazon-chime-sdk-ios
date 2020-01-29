//
//  Logger.swift
//  AmazonChimeSDK
//
//  Created by Wang, Haoran on 1/9/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

import Foundation

public protocol Logger {
    func `default`(msg: String)
    func debug(debugFunction: () -> String)
    func info(msg: String)
    func fault(msg: String)
    func error(msg: String)
    func setLogLevel(level: LogLevel)
    func getLogLevel() -> LogLevel
}
