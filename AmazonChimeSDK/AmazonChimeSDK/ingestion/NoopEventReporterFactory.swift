//
//  NoopEventReporterFactory.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers public class NoopEventReporterFactory: EventReporterFactory {
    public func createEventReporter() -> EventReporter? {
        return nil
    }
    public init() {}
}
