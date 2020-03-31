//
//  MeetingSessionCredentialsTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class MeetingSessionCredentialsTests: XCTestCase {
    func testMeetingSessionCredentialsShouldBeInitialized() {
        let credentials = MeetingSessionCredentials(attendeeId: "attendeeId", joinToken: "joinToken")

        XCTAssertEqual(credentials.attendeeId, "attendeeId")
        XCTAssertEqual(credentials.joinToken, "joinToken")
    }
}
