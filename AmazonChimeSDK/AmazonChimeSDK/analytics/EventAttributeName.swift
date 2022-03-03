//
//  EventAttributeName.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// EventAttributeName describes key of attributes that are passed in `EventAnalyticsObserver.eventDidReceive`
@objc public enum EventAttributeName: Int, CustomStringConvertible, CaseIterable {
    /// Name of device = Manufacturer of Device + Device Model
    case deviceName
    /// Manufacturer of Device
    case deviceManufacturer
    /// Model of Device
    case deviceModel
    /// Operating system name, which is "iOS"
    case osName
    /// Operating system version
    case osVersion
    /// Name of SDK, which is "amazon-chime-sdk-ios"
    case sdkName
    /// Version of SDK
    case sdkVersion
    /// Version of media SDK
    case mediaSdkVersion
    /// Timestamp of event occurrence
    case timestampMs
    /// AttendeeId
    case attendeeId
    /// External Meeting Id
    case externalMeetingId
    /// External Attendee Id
    case externalUserId
    /// Meeting Id
    case meetingId
    /// History of the meeting events in chronological order
    case meetingHistory
    // Followings are related to AudioVideo Event Attributes - meetingStartRequested, meetingStartSucceeded, meetingStartFailed, meetingEnded, meetingFailed

    /// Maximum number video tile shared during the meeting, including self video tile
    case maxVideoTileCount
    /// Duration of the meeting start process
    case meetingStartDurationMs
    /// Duration of the meeting
    case meetingDurationMs
    /// Error message of the meeting
    case meetingErrorMessage
    /// Meeting Status `MeetingSessionStatus`
    case meetingStatus
    /// The number of poor connection count during the meeting from start to end
    case poorConnectionCount
    /// The number of meeting retry connection count during the meeting from start to end
    case retryCount
    // Followings are related to Device Event Attributes - videoInputFailed

    /// The error of video input selection such as starting camera
    case videoInputError

    public var description: String {
        switch self {
        case .deviceName:
            return "deviceName"
        case .deviceManufacturer:
            return "deviceManufacturer"
        case .deviceModel:
            return "deviceModel"
        case .osName:
            return "osName"
        case .osVersion:
            return "osVersion"
        case .sdkName:
            return "sdkName"
        case .sdkVersion:
            return "sdkVersion"
        case .timestampMs:
            return "timestampMs"
        case .mediaSdkVersion:
            return "mediaSdkVersion"
        case .attendeeId:
            return "attendeeId"
        case .externalMeetingId:
            return "externalMeetingId"
        case .externalUserId:
            return "externalUserId"
        case .meetingId:
            return "meetingId"
        case .meetingHistory:
            return "meetingHistory"
        case .maxVideoTileCount:
            return "maxVideoTileCount"
        case .meetingStartDurationMs:
            return "meetingStartDurationMs"
        case .meetingDurationMs:
            return "meetingDurationMs"
        case .meetingErrorMessage:
            return "meetingErrorMessage"
        case .meetingStatus:
            return "meetingStatus"
        case .poorConnectionCount:
            return "poorConnectionCount"
        case .retryCount:
            return "retryCount"
        case .videoInputError:
            return "videoInputError"
        default:
            return ""
        }
    }
}
