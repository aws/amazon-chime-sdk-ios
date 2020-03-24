//
//  Scheduler.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
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
