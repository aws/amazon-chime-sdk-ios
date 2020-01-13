//
//  ConsoleLogger.swift
//  AmazonChimeSDK
//
//  Created by Wang, Haoran on 1/9/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

import Foundation
import os

public class ConsoleLogger: Logger {
    var name: String
    var level: LogLevel

    public init(name: String, level: LogLevel = .DEFAULT) {
        self.name = name
        self.level = level
    }

    public func `default`(msg: String) {
        self.log(type: .DEFAULT, msg: msg)
    }

    public func debug(debugFunction: () -> String) {
        self.log(type: .DEBUG, msg: debugFunction())
    }

    public func info(msg: String) {
        self.log(type: .INFO, msg: msg)
    }

    public func fault(msg: String) {
        self.log(type: .FAULT, msg: msg)
    }

    public func error(msg: String) {
        self.log(type: .ERROR, msg: msg)
    }

    public func setLogLevel(level: LogLevel) {
        self.level = level
    }

    public func getLogLevel() -> LogLevel {
        return self.level
    }

    private func log(type: LogLevel, msg: String) {
        if type.rawValue < self.level.rawValue {
            return
        }

        let logMessage = "[\(LogLevel.allCases[type.rawValue])] \(self.name) - " + msg

        switch type {
        case .DEFAULT:
            os_log("%@", type: .default, logMessage)
        case .DEBUG:
            os_log("%@", type: .debug, logMessage)
        case .INFO:
            os_log("%@", type: .info, logMessage)
        case .FAULT:
            os_log("%@", type: .fault, logMessage)
        case .ERROR:
            os_log("%@", type: .error, logMessage)
        case .OFF:
            return
        }
    }
}
