//
//  EventSender.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `EventSender` handles the sending of ingestion record
@objc public protocol EventSender {

    /// Send events as `IngestionRecord`
    /// - Parameters:
    ///   - ingestionRecord: ingestion record
    ///   - completionHandler: complete handler to execute when send event succeeded or failed
    func sendEvents(ingestionRecord: IngestionRecord, completionHandler: @escaping (Bool) -> Void)
}
