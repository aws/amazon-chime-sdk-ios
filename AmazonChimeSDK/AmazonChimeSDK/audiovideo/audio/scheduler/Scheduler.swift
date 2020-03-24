//
//  Scheduler.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

/**
 * `Scheduler` calls a callback on the schedule determined by the implementation.
 */
@objc public protocol Scheduler {
    /**
     * Schedules the callback according to the implementation.
     */
    func start()

    /**
     * Unschedules the callback and prevents it from being called anymore.
     */
    func stop()
}
