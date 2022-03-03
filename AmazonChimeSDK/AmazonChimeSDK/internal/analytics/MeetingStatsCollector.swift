//
//  MeetingStatsCollector.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objc public protocol MeetingStatsCollector {
    /// Increment meeting session retry count.
    func incrementRetryCount()

    /// Increment poor connection count during the meeting session based on audio quality.
    func incrementPoorConnectionCount()

    /// Add meeting history event.
    func addMeetingHistoryEvent(historyEventName: MeetingHistoryEventName, timestampMs: Int64)

    /// Update max video tile count during the meeting.
    ///
    /// - Parameter videoTileCount: current video tile count
    func updateMaxVideoTile(videoTileCount: Int)

    /// Update meetingStartConnectingTimeMs.
    func updateMeetingStartConnectingTimeMs()
    
    /// Update meetingStartTimeMs.
    func updateMeetingStartTimeMs()

    /// Clear internal states of `MeetingStatsCollector`.
    func resetMeetingStats()

    /// Retrieve meeting stats.
    func getMeetingStats() -> [AnyHashable: Any]

    /// Retrieve meeting history.
    func getMeetingHistory() -> [MeetingHistoryEvent]
}
