//
//  MeetingSessionCredentialsTest.swift
//  AmazonChimeSDKTests
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

@testable import AmazonChimeSDK
import XCTest

class MeetingSessionCredentialsTests: XCTestCase {
    func testMeetingSessionCredentialsShouldBeInitialized() {
        let credentials = MeetingSessionCredentials(attendeeId: "attendeeId", joinToken: "joinToken")
        XCTAssertEqual("attendeeId", credentials.attendeeId)
        XCTAssertEqual("joinToken", credentials.joinToken)
    }
}
