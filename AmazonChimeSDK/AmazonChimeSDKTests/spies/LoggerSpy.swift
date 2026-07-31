//
//  LoggerSpy.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Foundation

/// Records logging calls.
///
/// This spy is synchronized because the SDK logs from media threads as well as the
/// test thread: `DefaultAudioClient` is a process-wide singleton wrapping the real
/// `AudioClient`, and its `audioLogCallBack` forwards to whichever logger was last
/// passed to `DefaultAudioClient.shared(logger:)`. Recording into unsynchronized
/// arrays from two threads corrupts the heap (observed as a malloc abort in
/// `DefaultAudioClientControllerTests.testStart_failedToStart`).
class LoggerSpy: Logger {
    private let lock = NSLock()

    private var defaultCallsStorage: [String] = []
    private var debugCallsStorage: [String] = []
    private var infoCallsStorage: [String] = []
    private var faultCallsStorage: [String] = []
    private var errorCallsStorage: [String] = []
    private var setLogLevelCallsStorage: [LogLevel] = []

    var defaultCalls: [String] { return read { defaultCallsStorage } }
    var debugCalls: [String] { return read { debugCallsStorage } }
    var infoCalls: [String] { return read { infoCallsStorage } }
    var faultCalls: [String] { return read { faultCallsStorage } }
    var errorCalls: [String] { return read { errorCallsStorage } }
    var setLogLevelCalls: [LogLevel] { return read { setLogLevelCallsStorage } }

    var logLevelReturn: LogLevel = .DEFAULT

    private func read<T>(_ body: () -> T) -> T {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    private func write(_ body: () -> Void) {
        lock.lock()
        defer { lock.unlock() }
        body()
    }

    func `default`(msg: String) { write { defaultCallsStorage.append(msg) } }
    func debug(debugFunction: () -> String) {
        let msg = debugFunction()
        write { debugCallsStorage.append(msg) }
    }
    func info(msg: String) { write { infoCallsStorage.append(msg) } }
    func fault(msg: String) { write { faultCallsStorage.append(msg) } }
    func error(msg: String) { write { errorCallsStorage.append(msg) } }
    func setLogLevel(level: LogLevel) { write { setLogLevelCallsStorage.append(level) } }
    func getLogLevel() -> LogLevel { return logLevelReturn }
}
