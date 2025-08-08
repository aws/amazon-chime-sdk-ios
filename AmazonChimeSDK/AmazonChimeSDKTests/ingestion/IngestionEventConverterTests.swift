//
//  IngestionEventConverterTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import AVFoundation
import Mockingbird
import XCTest

class IngestionEventConverterTests: CommonTestCase {
    
    var converter: IngestionEventConverter!
    
    override func setUp() {
        super.setUp()
        converter = IngestionEventConverter()
    }
    
    func testToIngestionMeetingEvent_ShouldConvertAudioInputError_IfExists() {
        let event = SDKEvent(eventName: .audioInputFailed, eventAttributes: [
            EventAttributeName.audioInputError: TestError.simulatedFailure
        ])
        let result = converter.toIngestionMeetingEvent(event: event,
                                                       ingestionConfiguration: ingestionConfiguration)
        
        XCTAssertEqual(result.getAudioInputErrorMessage(), String(describing: TestError.simulatedFailure))
    }
    
    func testToIngestionRecord_ShouldReturnAudioInputErrorMessage_IfExists() {
        let ingestionMeetingEvent = IngestionMeetingEvent(name: EventName.audioInputFailed.description, eventAttributes: [
            EventAttributeName.audioInputError.description: AnyCodable(String(describing: TestError.simulatedFailure))
        ])
        let meetingEvent = MeetingEventItem(id: "test", data: ingestionMeetingEvent)
        let results = converter.toIngestionRecord(meetingEvents: [meetingEvent],
                                                  ingestionConfiguration: ingestionConfiguration)
        let resultErrorMessage = results.events.first!.payloads.first!.audioInputErrorMessage
        XCTAssertEqual(resultErrorMessage, String(describing: TestError.simulatedFailure))
    }
    
    func testToIngestionMeetingEvent_ShouldConvertVideoInputError_IfExists() {
        let event = SDKEvent(eventName: .videoInputFailed, eventAttributes: [
            EventAttributeName.videoInputError: TestError.simulatedFailure
        ])
        let result = converter.toIngestionMeetingEvent(event: event,
                                                       ingestionConfiguration: ingestionConfiguration)
        
        XCTAssertEqual(result.getVideoInputErrorMessage(), String(describing: TestError.simulatedFailure))
    }
    
    func testToIngestionRecord_ShouldReturnVideoInputErrorMessage_IfExists() {
        let ingestionMeetingEvent = IngestionMeetingEvent(name: EventName.videoInputFailed.description, eventAttributes: [
            EventAttributeName.videoInputError.description: AnyCodable(String(describing: TestError.simulatedFailure))
        ])
        let meetingEvent = MeetingEventItem(id: "test", data: ingestionMeetingEvent)
        let results = converter.toIngestionRecord(meetingEvents: [meetingEvent],
                                                  ingestionConfiguration: ingestionConfiguration)
        let resultErrorMessage = results.events.first!.payloads.first!.videoInputErrorMessage
        XCTAssertEqual(resultErrorMessage, String(describing: TestError.simulatedFailure))
    }
}
