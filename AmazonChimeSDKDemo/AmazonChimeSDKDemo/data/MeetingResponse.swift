//
//  MeetingResponse.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

struct CreateMediaPlacementInfo: Codable {
    var audioFallbackUrl: String
    var audioHostUrl: String
    var turnControlUrl: String
    var signalingUrl: String

    enum CodingKeys: String, CodingKey {
        case audioFallbackUrl = "AudioFallbackUrl"
        case audioHostUrl = "AudioHostUrl"
        case turnControlUrl = "TurnControlUrl"
        case signalingUrl = "SignalingUrl"
    }
}

struct CreateMeetingInfo: Codable {
    var meetingId: String
    var mediaPlacement: CreateMediaPlacementInfo

    enum CodingKeys: String, CodingKey {
        case meetingId = "MeetingId"
        case mediaPlacement = "MediaPlacement"
    }
}

struct CreateAttendeeInfo: Codable {
    var attendeeId: String
    var joinToken: String

    enum CodingKeys: String, CodingKey {
        case attendeeId = "AttendeeId"
        case joinToken = "JoinToken"
    }
}

struct CreateJoinInfo: Codable {
    var title: String
    var meeting: CreateMeetingInfo
    var attendee: CreateAttendeeInfo

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case meeting = "Meeting"
        case attendee = "Attendee"
    }
}

struct MeetingResponse: Codable {
    var joinInfo: CreateJoinInfo

    enum CodingKeys: String, CodingKey {
        case joinInfo = "JoinInfo"
    }
}
