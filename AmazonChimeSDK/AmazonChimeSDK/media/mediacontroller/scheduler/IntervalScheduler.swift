//
//  IntervalScheduler.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

/**
 * [[IntervalScheduler]] calls the callback every intervalMs milliseconds.
 */
@objcMembers public class IntervalScheduler: Scheduler {
    var timer: Timer?
    var cb: () -> Void
    var intervalMs: Int
    let ONE_SECOND = 1000.0
    
    init(intervalMs: Int, callback: @escaping () -> Void) {
        self.cb = callback
        self.intervalMs = intervalMs
    }
    
    @objc private func runCallback() {
        self.cb()
    }
    
    public func start() {
        self.stop()
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(Double(self.intervalMs) / ONE_SECOND), target: self, selector: #selector(self.runCallback), userInfo: nil, repeats: true)
    }
    
    public func stop() {
        if self.timer != nil {
            self.timer?.invalidate()
        }
    }
}
