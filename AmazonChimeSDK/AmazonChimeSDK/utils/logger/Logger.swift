//
//  Logger.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

@objc public protocol Logger {
    func `default`(msg: String)
    func debug(debugFunction: () -> String)
    func info(msg: String)
    func fault(msg: String)
    func error(msg: String)
    func setLogLevel(level: LogLevel)
    func getLogLevel() -> LogLevel
}
