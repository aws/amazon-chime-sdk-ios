//
//  IntervalScheduler.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/**
 * `IntervalScheduler` calls the callback every intervalMs milliseconds.
 */
@objcMembers public class IntervalScheduler: Scheduler {
    var timer: Timer?
    var callback: () -> Void
    var intervalMs: Int
    let oneSecond = 1000.0

    init(intervalMs: Int, callback: @escaping () -> Void) {
        self.callback = callback
        self.intervalMs = intervalMs
    }

    @objc private func runCallback() {
        self.callback()
    }

    public func start() {
        self.stop()
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(Double(self.intervalMs) / self.oneSecond),
                                          target: self,
                                          selector: #selector(self.runCallback),
                                          userInfo: nil,
                                          repeats: true)
    }

    public func stop() {
        if self.timer != nil {
            self.timer?.invalidate()
        }
    }
}
