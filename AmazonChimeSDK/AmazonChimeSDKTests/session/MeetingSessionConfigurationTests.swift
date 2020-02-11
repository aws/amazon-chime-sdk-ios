//
//  MeetingSessionConfigurationTest.swift
//  AmazonChimeSDKTests
//
//  Created by Wang, Haoran on 2/4/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

@testable import AmazonChimeSDK
import XCTest

class MeetingSessionConfigurationTests: XCTestCase {

    func testMediaPlacementShouldBeInitialized() {
        let mediaPlacement = MediaPlacement(audioHostURL: "audioHostURL")
        XCTAssertEqual("audioHostURL", mediaPlacement.audioHostURL)
    }

    func testMeetingShouldBeInitialized() {
        let mediaPlacement = MediaPlacement(audioHostURL: "audioHostURL")
        let meeting = Meeting(meetingId: "meetingId", mediaPlacement: mediaPlacement)
        XCTAssertEqual("meetingId", meeting.meetingId)
        XCTAssertEqual(mediaPlacement.audioHostURL, meeting.mediaPlacement.audioHostURL)
    }

    func testCreateMeetingResponseShouldBeInitialized() {
        let mediaPlacement = MediaPlacement(audioHostURL: "audioHostURL")
        let meeting = Meeting(meetingId: "meetingId", mediaPlacement: mediaPlacement)

        let meetingResponse = CreateMeetingResponse(meeting: meeting)
        XCTAssertEqual(meeting.meetingId, meetingResponse.meeting.meetingId)
        XCTAssertEqual(meeting.mediaPlacement.audioHostURL, meetingResponse.meeting.mediaPlacement.audioHostURL)
    }
    
    func testAttendeeShouldBeInitialized() {
        let attendee = Attendee(attendeeId: "attendeeId", joinToken: "joinToken")
        XCTAssertEqual("attendeeId", attendee.attendeeId)
        XCTAssertEqual("joinToken", attendee.joinToken)
    }

    func testCreateAttendeeResponseShouldBeInitialized() {
        let attendee = Attendee(attendeeId: "attendeeId", joinToken: "joinToken")

        let attendeeResponse = CreateAttendeeResponse(attendee: attendee)
        XCTAssertEqual(attendee.attendeeId, attendeeResponse.attendee.attendeeId)
        XCTAssertEqual(attendee.joinToken, attendeeResponse.attendee.joinToken)
    }

    func testMeetingSessionConfigurationShouldBeInitialized() {
        let mediaPlacement = MediaPlacement(audioHostURL: "audioHostURL")
        let meeting = Meeting(meetingId: "meetingId", mediaPlacement: mediaPlacement)
        let meetingResponse = CreateMeetingResponse(meeting: meeting)
        let attendee = Attendee(attendeeId: "attendeeId", joinToken: "joinToken")
        let attendeeResponse = CreateAttendeeResponse(attendee: attendee)

        let configuration = MeetingSessionConfiguration(createMeetingResponse: meetingResponse,
                                                        createAttendeeResponse: attendeeResponse)
        XCTAssertEqual(meeting.meetingId, configuration.meetingId)
        XCTAssertEqual(mediaPlacement.audioHostURL, configuration.urls.audioHostURL)
        XCTAssertEqual(attendee.attendeeId, configuration.credentials.attendeeId)
        XCTAssertEqual(attendee.joinToken, configuration.credentials.joinToken)
    }

}
