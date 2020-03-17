//
//  AttendeeInfoTests.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

@testable import AmazonChimeSDK
import XCTest

class AttendeeInfoTests: XCTestCase {
    private let attendeeId = "attendeeId"
    private let externalUserId = ""

    func testAttendeeInfoShouldBeInitialized() {
        let attendeeInfo = AttendeeInfo(attendeeId: attendeeId, externalUserId: externalUserId)
        XCTAssertEqual(attendeeId, attendeeInfo.attendeeId)
        XCTAssertEqual(externalUserId, attendeeInfo.externalUserId)
    }

    func testAttendeeInfoShouldBeEqualWhenInitializedWithSameParameters() {
        let attendeeInfo1 = AttendeeInfo(attendeeId: attendeeId, externalUserId: externalUserId)
        let attendeeInfo2 = AttendeeInfo(attendeeId: attendeeId, externalUserId: externalUserId)
        let attendeeInfo3 = AttendeeInfo(attendeeId: "otherAttendeeId", externalUserId: externalUserId)
        XCTAssertEqual(attendeeInfo1, attendeeInfo2)
        XCTAssertTrue(attendeeInfo1 != attendeeInfo3)
    }

    func testAttendeeInfoShouldBeOrderedAlphabetically() {
        let attendeeInfo1 = AttendeeInfo(attendeeId: attendeeId, externalUserId: externalUserId)
        let attendeeInfo2 = AttendeeInfo(attendeeId: "attendeeId2", externalUserId: externalUserId)
        XCTAssertTrue(attendeeInfo1 < attendeeInfo2)
    }
}
