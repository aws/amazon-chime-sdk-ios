//
//  TranscriptEventObserver.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `TranscriptEventObserver` provides a callback to handle transcript event
@objc public protocol TranscriptEventObserver {
    /// Gets triggered when a transcript event is received
    ///
    /// Note: this callback will be called on main thread.
    ///
    /// - Parameter transcriptEvent: The transcript event received
    func transcriptEventDidReceive(transcriptEvent: TranscriptEvent)
}
