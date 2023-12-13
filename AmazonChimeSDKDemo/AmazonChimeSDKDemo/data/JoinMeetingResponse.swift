//
//  MeetingResponse.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

struct CreateMediaPlacementInfo: Codable {
    var audioFallbackUrl: String?
    var audioHostUrl: String
    var signalingUrl: String
    var turnControlUrl: String?
    var eventIngestionUrl: String?

    enum CodingKeys: String, CodingKey {
        case audioFallbackUrl = "AudioFallbackUrl"
        case audioHostUrl = "AudioHostUrl"
        case signalingUrl = "SignalingUrl"
        case turnControlUrl = "TurnControlUrl"
        case eventIngestionUrl = "EventIngestionUrl"
    }
}

// meeting features
struct AudioFeatures: Codable {
    var echoReduction: String?
    enum CodingKeys: String, CodingKey {
        case echoReduction = "EchoReduction"
    }
}

struct VideoFeatures: Codable {
    var maxResolution: String?
    enum CodingKeys: String, CodingKey {
        case maxResolution = "MaxResolution"
    }
}

struct AttendeeFeatures: Codable {
    var maxCount: Int?
    enum CodingKeys: String, CodingKey {
        case maxCount = "MaxCount"
    }
}

struct CreateMeetingFeatures: Codable {
    var audio: AudioFeatures?
    var video: VideoFeatures?
    var content: VideoFeatures?
    var attendee: AttendeeFeatures?

    enum CodingKeys: String, CodingKey {
        case audio = "Audio"
        case video = "Video"
        case content = "Content"
        case attendee = "Attendee"
    }
}

struct CreateMeetingInfo: Codable {
    var externalMeetingId: String?
    var primaryMeetingId: String?
    var mediaPlacement: CreateMediaPlacementInfo
    var meetingFeatures: CreateMeetingFeatures?
    var mediaRegion: String
    var meetingId: String

    enum CodingKeys: String, CodingKey {
        case externalMeetingId = "ExternalMeetingId"
        case primaryMeetingId = "PrimaryMeetingId"
        case mediaPlacement = "MediaPlacement"
        case meetingFeatures = "MeetingFeatures"
        case mediaRegion = "MediaRegion"
        case meetingId = "MeetingId"
    }
}

struct CreateAttendeeInfo: Codable {
    var attendeeId: String
    var externalUserId: String
    var joinToken: String

    enum CodingKeys: String, CodingKey {
        case attendeeId = "AttendeeId"
        case externalUserId = "ExternalUserId"
        case joinToken = "JoinToken"
    }
}

struct CreateMeeting: Codable {
    var meeting: CreateMeetingInfo

    enum CodingKeys: String, CodingKey {
        case meeting = "Meeting"
    }
}

struct CreateAttendee: Codable {
    var attendee: CreateAttendeeInfo

    enum CodingKeys: String, CodingKey {
        case attendee = "Attendee"
    }
}

struct CreateJoinInfo: Codable {
    var meeting: CreateMeeting
    var attendee: CreateAttendee
    var primaryExternalMeetingId: String?

    enum CodingKeys: String, CodingKey {
        case meeting = "Meeting"
        case attendee = "Attendee"
        case primaryExternalMeetingId = "PrimaryExternalMeetingId"
    }
}

struct JoinMeetingResponse: Codable {
    var joinInfo: CreateJoinInfo

    enum CodingKeys: String, CodingKey {
        case joinInfo = "JoinInfo"
    }
}
