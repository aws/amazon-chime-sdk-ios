//
//  IntervalScheduler.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

private let millisPerSecond = 1000.0

/**
 * `IntervalScheduler` calls the callback every intervalMs milliseconds.
 */
@objcMembers public class IntervalScheduler: Scheduler {
    private enum IntervalSchedulerState {
        case started
        case stopped
    }

    private let timer: DispatchSourceTimer
    private var state: IntervalSchedulerState = .stopped

    init(intervalMs: Int, callback: @escaping () -> Void) {
        let timeInterval = TimeInterval(Double(intervalMs) / millisPerSecond)
        let timer = DispatchSource.makeTimerSource()
        timer.schedule(deadline: .now() + timeInterval, repeating: timeInterval)
        timer.setEventHandler(handler: callback)

        self.timer = timer
    }

    deinit {
        timer.setEventHandler {}
        timer.cancel()

        // Need to resume the canceled timer to avoid crash:
        // https://forums.developer.apple.com/message/46175
        start()
    }

    public func start() {
        if state == .started {
            return
        }
        state = .started
        timer.resume()
    }

    public func stop() {
        if state == .stopped {
            return
        }
        state = .stopped
        timer.suspend()
    }
}
