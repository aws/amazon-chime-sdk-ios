//
//  DefaultEventReporter.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers public class DefaultEventReporter: NSObject, EventReporter {
    private let eventBuffer: EventBuffer
    private let ingestionConfiguration: IngestionConfiguration
    private let logger: Logger
    private var timer: Scheduler?
    private var isStarted = false

    init(ingestionConfiguration: IngestionConfiguration,
         eventBuffer: EventBuffer,
         logger: Logger,
         timer: Scheduler? = nil) {
        self.eventBuffer = eventBuffer
        self.ingestionConfiguration = ingestionConfiguration
        self.logger = logger
        self.timer = timer
        super.init()
        start()
    }

    public func report(event: SDKEvent) {
        if ingestionConfiguration.disabled {
            return
        }

        eventBuffer.add(item: event)
    }

    public func start() {
        if isStarted {
            return
        }
        
        isStarted = true

        if timer == nil {
            timer = IntervalScheduler(
                intervalMs: Int(ingestionConfiguration.flushIntervalMs),
                callback: { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.eventBuffer.process()
                }
            )
        }

        timer?.start()
    }

    public func stop() {
        if !isStarted {
            return
        }

        timer?.stop()
        
        isStarted = false
    }

    deinit {
        timer?.stop()
    }
}
