//
//  AmazonChimeSDKTests.swift
//  AmazonChimeSDKTests
//
//  Created by Wang, Haoran on 1/6/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

@testable import AmazonChimeSDK
import XCTest

class AmazonChimeSDKTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testCreatingMeetingSessionConfiguration() {
        let meetingResponse = CreateMeetingResponse(meeting:
            Meeting(meetingId: "meetingId",
                    mediaPlacement: MediaPlacement(audioHostUrl: "audioHostUrl",
                                                   turnControlUrl: "turnControlUrl",
                                                   signalingUrl: "signalingUrl")))
        let attendeeResponse = CreateAttendeeResponse(attendee:
            Attendee(attendeeId: "attendeeId", joinToken: "joinToken"))
        let config = MeetingSessionConfiguration(createMeetingResponse:
            meetingResponse, createAttendeeResponse: attendeeResponse)
        XCTAssertEqual("meetingId", config.meetingId)
        XCTAssertEqual("audioHostUrl", config.urls.audioHostURL)
        XCTAssertEqual("attendeeId", config.credentials.attendeeId)
        XCTAssertEqual("joinToken", config.credentials.joinToken)
    }

    func testLogger() {
        var logger = ConsoleLogger(name: "test log default")
        XCTAssertEqual(LogLevel.DEFAULT, logger.getLogLevel())

        logger = ConsoleLogger(name: "test log debug", level: LogLevel.DEBUG)
        XCTAssertEqual(LogLevel.DEBUG, logger.getLogLevel())

        logger = ConsoleLogger(name: "test log info", level: LogLevel.INFO)
        XCTAssertEqual(LogLevel.INFO, logger.getLogLevel())

        logger = ConsoleLogger(name: "test log fault", level: LogLevel.FAULT)
        XCTAssertEqual(LogLevel.FAULT, logger.getLogLevel())

        logger = ConsoleLogger(name: "test log error", level: LogLevel.ERROR)
        XCTAssertEqual(LogLevel.ERROR, logger.getLogLevel())

        logger = ConsoleLogger(name: "test log off", level: LogLevel.OFF)
        XCTAssertEqual(LogLevel.OFF, logger.getLogLevel())

        logger.setLogLevel(level: LogLevel.FAULT)
        XCTAssertEqual(LogLevel.FAULT, logger.getLogLevel())
    }
}
