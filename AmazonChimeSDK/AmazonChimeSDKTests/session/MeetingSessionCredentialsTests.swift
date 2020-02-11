//
//  MeetingSessionCredentialsTest.swift
//  AmazonChimeSDKTests
//
//  Created by Wang, Haoran on 2/4/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
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
