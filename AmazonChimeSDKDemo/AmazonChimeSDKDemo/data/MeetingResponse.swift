//
//  MeetingResponse.swift
//  AmazonChimeSDKDemo
//
//  Created by Hwang, Hokyung on 1/29/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

import Foundation

struct MediaPlacementInfo: Codable {
    var audioHostUrl: String
    var turnControlUrl: String
    var signalingUrl: String

    enum CodingKeys: String, CodingKey {
        case audioHostUrl = "AudioHostUrl"
        case turnControlUrl = "TurnControlUrl"
        case signalingUrl = "SignalingUrl"
    }
}

struct MeetingInfo: Codable {
    var meetingId: String
    var mediaPlacement: MediaPlacementInfo

    enum CodingKeys: String, CodingKey {
        case meetingId = "MeetingId"
        case mediaPlacement = "MediaPlacement"
    }
}

struct AttendeeInfo: Codable {
    var attendeeId: String
    var joinToken: String

    enum CodingKeys: String, CodingKey {
        case attendeeId = "AttendeeId"
        case joinToken = "JoinToken"
    }
}

struct JoinInfo: Codable {
    var title: String
    var meeting: MeetingInfo
    var attendee: AttendeeInfo

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case meeting = "Meeting"
        case attendee = "Attendee"
    }
}

struct MeetingResponse: Codable {
    var joinInfo: JoinInfo

    enum CodingKeys: String, CodingKey {
        case joinInfo = "JoinInfo"
    }
}
