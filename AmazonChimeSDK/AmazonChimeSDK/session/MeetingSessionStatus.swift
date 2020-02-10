//
//  MeetingSessionStatus.swift
//  AmazonChimeSDK
//
//  Created by Hwang, Hokyung on 1/29/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

import Foundation

public class MeetingSessionStatus {
    public let statusCode: MeetingSessionStatusCode?

    init(statusCode: MeetingSessionStatusCode?) {
        self.statusCode = statusCode
    }
}
