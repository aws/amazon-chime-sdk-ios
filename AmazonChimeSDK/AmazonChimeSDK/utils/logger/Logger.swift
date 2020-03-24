//
//  Logger.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `Logger` defines how to write logs for different logging level.
@objc public protocol Logger {
    /// Emits any message if the log level is equal to or lower than default level.
    func `default`(msg: String)

    /// Calls `debugFunction` only if the log level is debug and emits the
    /// resulting string. Use the debug level to dump large or verbose messages
    /// that could slow down performance.
    func debug(debugFunction: () -> String)

    /// Emits an info message if the log level is equal to or lower than info level.
    func info(msg: String)

    /// Emits a fault message if the log level is equal to or lower than fault level.
    func fault(msg: String)

    /// Emits an error message if the log level is equal to or lower than error level.
    func error(msg: String)

    /// Sets the log level.
    func setLogLevel(level: LogLevel)

    /// Gets the current log level.
    func getLogLevel() -> LogLevel
}
