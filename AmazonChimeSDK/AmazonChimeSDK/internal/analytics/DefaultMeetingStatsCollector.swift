//
//  DefaultMeetingStatsCollector.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers public class DefaultMeetingStatsCollector: NSObject, MeetingStatsCollector {
    private let logger: Logger
    private var meetingStartTimeMs: Int64 = 0
    private var meetingStartConnectingTimeMs: Int64 = 0
    private var retryCount: Int = 0
    private var poorConnectionCount: Int = 0
    private var maxVideoTileCount: Int = 0
    private var meetingHistory: [MeetingHistoryEvent] = []

    init(logger: Logger) {
        self.logger = logger
        super.init()
    }

    public func getMeetingHistory() -> [MeetingHistoryEvent] {
        return meetingHistory
    }

    public func getMeetingStats() -> [AnyHashable: Any] {
        return [EventAttributeName.maxVideoTileCount: maxVideoTileCount,
                EventAttributeName.retryCount: retryCount,
                EventAttributeName.poorConnectionCount: poorConnectionCount,
                EventAttributeName.meetingStartDurationMs: meetingStartTimeMs == 0 ?
                    0 : meetingStartTimeMs - meetingStartConnectingTimeMs,
                EventAttributeName.meetingDurationMs: meetingStartTimeMs == 0 ?
                    0 : DateUtils.getCurrentTimeStampMs() - meetingStartTimeMs
        ] as [EventAttributeName: Any]
    }

    public func addMeetingHistoryEvent(historyEventName: MeetingHistoryEventName, timestampMs: Int64) {
        meetingHistory.append(MeetingHistoryEvent(meetingHistoryEventName: historyEventName,
                                                  timestampMs: timestampMs))
    }

    public func incrementRetryCount() {
        retryCount += 1
    }

    public func incrementPoorConnectionCount() {
        poorConnectionCount += 1
    }

    public func updateMaxVideoTile(videoTileCount: Int) {
        maxVideoTileCount = max(videoTileCount, maxVideoTileCount)
    }

    public func updateMeetingStartConnectingTimeMs() {
        meetingStartConnectingTimeMs = DateUtils.getCurrentTimeStampMs()
    }
    
    public func updateMeetingStartTimeMs() {
        meetingStartTimeMs = DateUtils.getCurrentTimeStampMs()
    }

    public func resetMeetingStats() {
        retryCount = 0
        poorConnectionCount = 0
        maxVideoTileCount = 0
        meetingStartTimeMs = 0
        meetingStartConnectingTimeMs = 0
    }
}
