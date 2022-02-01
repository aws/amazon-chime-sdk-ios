//
//  IngestionEventAttributes.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

class IngestionEventAttributes: Codable {
    /// Timestamp of event occurrence
    public let timestampMs: Int64?
    public let maxVideoTileCount: Int?
    /// Duration of the meeting start process
    public let meetingStartDurationMs: Int64?
    /// Duration of the meeting
    public let meetingDurationMs: Int64?
    /// Error message of the meeting
    public let meetingErrorMessage: String?
    /// Meeting Status `MeetingSessionStatus`
    public let meetingStatus: String?
    /// The number of poor connection count during the meeting from start to end
    public let poorConnectionCount: Int?
    /// The number of meeting retry connection count during the meeting from start to end
    public let retryCount: Int?
    /// The error of video input selection such as starting camera
    public let videoInputError: String?
    /// The id of the meeting
    public let meetingId: String?
    /// The id of the attendee
    public let attendeeId: String?

    init(timestampMs: Int64? = nil,
         maxVideoTileCount: Int? = nil,
         meetingStartDurationMs: Int64? = nil,
         meetingDurationMs: Int64? = nil,
         meetingErrorMessage: String? = nil,
         meetingStatus: String? = nil,
         poorConnectionCount: Int? = nil,
         retryCount: Int? = nil,
         videoInputError: String? = nil,
         meetingId: String? = nil,
         attendeeId: String? = nil) {
        self.timestampMs = timestampMs
        self.maxVideoTileCount = maxVideoTileCount
        self.meetingStartDurationMs = meetingStartDurationMs
        self.meetingDurationMs = meetingDurationMs
        self.meetingErrorMessage = meetingErrorMessage
        self.meetingStatus = meetingStatus
        self.poorConnectionCount = poorConnectionCount
        self.retryCount = retryCount
        self.videoInputError = videoInputError
        self.meetingId = meetingId
        self.attendeeId = attendeeId
    }
}
