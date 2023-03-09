//
//  EventAttributeUtilsTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class EventAttributeUtilsTests: XCTestCase {
    
    func testGetCommonAttributesShouldReturnBothCommonAndMetadataAttributes() {
        let meetingId = "test_meeting_id_123"
        let attendeeId = "test_attendee_id_123"
        let clientConfig = MeetingEventClientConfiguration(eventClientJoinToken: "",
                                                           meetingId: meetingId,
                                                           attendeeId: attendeeId)
        let ingestionConfig = IngestionConfiguration(clientConfiguration: clientConfig,
                                                     ingestionUrl: "",
                                                     disabled: false,
                                                     flushSize: 1,
                                                     flushIntervalMs: 1,
                                                     retryCountLimit: 1)
        let attributes = EventAttributeUtils.getCommonAttributes(ingestionConfiguration: ingestionConfig)
        for commonAttribute in EventAttributeUtils.commonEventAttributes {
            XCTAssertNotNil(attributes[commonAttribute.key])
        }
        XCTAssertEqual(attributes[EventAttributeName.meetingId.description] as? String, meetingId)
        XCTAssertEqual(attributes[EventAttributeName.attendeeId.description] as? String, attendeeId)
    }
    
    func testGetCommonAttributesShouldReturnBothCommonAndMeetingInfoAttributes() {
        let meetingId = "test_meeting_id_123"
        let attendeeId = "test_attendee_id_123"
        let externalMeetingId = "test_external_meeting_id_123"
        let externalUserId = "test_external_user_id_123"
        let credentials = MeetingSessionCredentials(attendeeId: attendeeId,
                                                    externalUserId: externalUserId,
                                                    joinToken: "")
        let meetingSessionUrls = MeetingSessionURLs(audioFallbackUrl: "",
                                                    audioHostUrl: "",
                                                    turnControlUrl: "",
                                                    signalingUrl: "",
                                                    urlRewriter: URLRewriterUtils.defaultUrlRewriter)
        let config = MeetingSessionConfiguration(meetingId: meetingId,
                                                 externalMeetingId: externalMeetingId,
                                                 credentials: credentials,
                                                 urls: meetingSessionUrls,
                                                 urlRewriter: URLRewriterUtils.defaultUrlRewriter)
        
        let attributes = EventAttributeUtils.getCommonAttributes(meetingSessionConfig: config)
        for commonAttribute in EventAttributeUtils.commonEventAttributes {
            XCTAssertNotNil(attributes[commonAttribute.key])
        }
        XCTAssertEqual(attributes[EventAttributeName.meetingId.description] as? String, meetingId)
        XCTAssertEqual(attributes[EventAttributeName.attendeeId.description] as? String, attendeeId)
        XCTAssertEqual(attributes[EventAttributeName.externalMeetingId.description] as? String, externalMeetingId)
        XCTAssertEqual(attributes[EventAttributeName.externalUserId.description] as? String, externalUserId)
    }
}
