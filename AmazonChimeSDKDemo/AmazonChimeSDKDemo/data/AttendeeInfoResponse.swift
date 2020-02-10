//
//  AttendeeInfoResponse.swift
//  AmazonChimeSDKDemo
//
//  Created by Hwang, Hokyung on 1/29/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

import Foundation

struct AttendeeIdName: Codable {
    var attendeeId: String
    var name: String

    enum CodingKeys: String, CodingKey {
        case attendeeId = "AttendeeId"
        case name = "Name"
    }
}

struct AttendeeInfoResponse: Codable {
    var attendeeInfo: AttendeeIdName

    enum CodingKeys: String, CodingKey {
        case attendeeInfo = "AttendeeInfo"
    }
}
