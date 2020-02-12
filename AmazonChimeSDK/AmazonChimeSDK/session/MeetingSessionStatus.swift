//
//  MeetingSessionStatus.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

public class MeetingSessionStatus {
    let statusCode: MeetingSessionStatusCode

    public init(statusCode: MeetingSessionStatusCode) {
        self.statusCode = statusCode
    }
}
