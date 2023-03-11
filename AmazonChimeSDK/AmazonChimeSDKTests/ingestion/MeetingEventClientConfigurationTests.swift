//
//  MeetingEventClientConfigurationTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class MeetingEventClientConfigurationTests: XCTestCase {
    
    func testConfigShouldPutMeetingIdAndAttendeeIdInMetadataAttributes() {
        let testMeetingId = "meeting_id_123"
        let testAttendeeId = "attendee_id_123"
        let config = MeetingEventClientConfiguration(eventClientJoinToken: "",
                                                     meetingId: testMeetingId,
                                                     attendeeId: testAttendeeId)
        guard let meetingId = config.metadataAttributes[EventAttributeName.meetingId.description] as? String else {
            XCTFail("`meetingId` is nil")
            return
        }
        guard let attendeeId = config.metadataAttributes[EventAttributeName.attendeeId.description] as? String else {
            XCTFail("`attendeeId` is nil")
            return
        }
        XCTAssertEqual(testMeetingId, meetingId)
        XCTAssertEqual(testAttendeeId, attendeeId)
    }
}
