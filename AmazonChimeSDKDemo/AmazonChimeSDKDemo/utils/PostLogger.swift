//
//  PostLogger.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AmazonChimeSDK
import os

class PostLogger: AmazonChimeSDK.Logger {
    private let name: String
    private var level: LogLevel
    private let meetingConfig: MeetingSessionConfiguration
    private let url: String
    private var logEntries: [LogEntry] = []
    private var sequenceNumber = 0

    init(name: String, configuration: MeetingSessionConfiguration, url: String, logLevel: LogLevel = LogLevel.INFO) {
        self.level = logLevel
        self.meetingConfig = configuration
        self.name = name
        self.url = url
    }

    func `default`(msg: String) {
        log(level: .DEFAULT, msg: msg)
    }

    func debug(debugFunction: () -> String) {
        log(level: .DEBUG, msg: debugFunction())
    }

    func info(msg: String) {
        log(level: .INFO, msg: msg)
    }

    func fault(msg: String) {
        log(level: .FAULT, msg: msg)
    }

    func error(msg: String) {
        log(level: .ERROR, msg: msg)
    }

    func setLogLevel(level: LogLevel) {
        self.level = level
    }

    func getLogLevel() -> LogLevel {
        return level
    }

    func publishLog() {
        let requestBody = LogRequestBody(meetingId: meetingConfig.meetingId,
                                         attendeeId: meetingConfig.credentials.attendeeId,
                                         appName: name,
                                         logs: logEntries)
        guard let nonNilData = try? JSONEncoder().encode(requestBody) else {
            return
        }

        HttpUtils.postRequest(url: self.url, jsonData: nonNilData) { _, error in
            if let error = error {
                os_log("%@", type: .error, "PostLogger post request failed \(error)")
            } else {
                os_log("%@", type: .info, "PostLogger post request succeeded")
                self.logEntries.removeAll()
            }
        }
    }

    private func log(level: LogLevel, msg: String) {
        if level.rawValue < self.level.rawValue {
            return
        }
        logEntries.append(LogEntry(sequenceNumber: sequenceNumber,
                        message: msg,
                        timestampMs: Int64(Date().timeIntervalSince1970 * 1000),
                        logLevel: String(describing: level)))
        sequenceNumber += 1
    }
}
