//
//  ConsoleLogger.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import os

/// ConsoleLogger writes logs with console.
///
/// ```
/// // working with the ConsoleLogger
/// let logger = new ConsoleLogger("demo"); //default level is LogLevel.DEFAULT prints everything
/// logger.info("info");
/// logger.debug("debug");
/// logger.fault("fault");
/// logger.error("error");
///
/// // setting logging levels
/// let logger = new ConsoleLogger("demo", .INFO);
/// logger.debug("debug"); // does not print
/// logger.setLogLevel(LogLevel.DEBUG)
/// logger.debug("debug"); // print
/// ```
@objcMembers public class ConsoleLogger: NSObject, Logger {
    let name: String
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
        default:
            return
        }
    }
}
