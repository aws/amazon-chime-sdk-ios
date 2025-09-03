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
    
    func testToIngestionMeetingEvent_ShouldConvertAttributes_IfExists() {
        let event = SDKEvent(eventName: .audioInputFailed, eventAttributes: [
            EventAttributeName.audioInputError: TestError.audioInputError,
            EventAttributeName.videoInputError: TestError.videoInputError,
            EventAttributeName.signalingDroppedError: TestError.signalingDroppedError,
            EventAttributeName.appState: AppState.background
        ])
        let result = converter.toIngestionMeetingEvent(event: event,
                                                       ingestionConfiguration: ingestionConfiguration)
        
        XCTAssertEqual(result.getAudioInputErrorMessage(), String(describing: TestError.audioInputError))
        XCTAssertEqual(result.getVideoInputErrorMessage(), String(describing: TestError.videoInputError))
        XCTAssertEqual(result.getSignalingDroppedErrorMessage(), String(describing: TestError.signalingDroppedError))
        XCTAssertEqual(result.getAppState(), String(describing: AppState.background))
    }
    
    func testToIngestionRecord_ShouldReturnAttributes_IfExists() {
        let ingestionMeetingEvent = IngestionMeetingEvent(name: EventName.audioInputFailed.description,
                                                          eventAttributes: [
            EventAttributeName.audioInputError.description: AnyCodable(String(describing: TestError.audioInputError)),
            EventAttributeName.videoInputError.description: AnyCodable(String(describing: TestError.videoInputError)),
            EventAttributeName.signalingDroppedError.description: AnyCodable(String(describing: TestError.signalingDroppedError)),
            EventAttributeName.appState.description: AnyCodable(String(describing: AppState.background))
        ])
        let meetingEvent = MeetingEventItem(id: "test", data: ingestionMeetingEvent)
        let results = converter.toIngestionRecord(meetingEvents: [meetingEvent],
                                                  ingestionConfiguration: ingestionConfiguration)
        let audioInputErrorMessage = results.events.first!.payloads.first!.audioInputErrorMessage
        XCTAssertEqual(audioInputErrorMessage, String(describing: TestError.audioInputError))
        
        let videoInputErrorMessage = results.events.first!.payloads.first!.videoInputErrorMessage
        XCTAssertEqual(videoInputErrorMessage, String(describing: TestError.videoInputError))
        
        let signalingDroppedErrorMessage = results.events.first!.payloads.first!.signalingDroppedErrorMessage
        XCTAssertEqual(signalingDroppedErrorMessage, String(describing: TestError.signalingDroppedError))
        
        let appStateStr = results.events.first!.payloads.first!.appState
        XCTAssertEqual(appStateStr, String(describing: AppState.background))
    }
}
