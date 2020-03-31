//
//  AttendeeInfoTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
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

        XCTAssertEqual(attendeeInfo1, attendeeInfo2)
    }

    func testEqualizationShouldReturnFalseWhenTestAttendeeInfoAgainstOtherType() {
        let attendeeInfo = AttendeeInfo(attendeeId: attendeeId, externalUserId: externalUserId)
        let volumeUpdate = VolumeUpdate(attendeeInfo: attendeeInfo, volumeLevel: .muted)

        XCTAssertNotEqual(attendeeInfo, volumeUpdate)
    }

    func testAttendeeInfoShouldBeOrderedAlphabetically() {
        let attendeeInfo1 = AttendeeInfo(attendeeId: attendeeId, externalUserId: externalUserId)
        let attendeeInfo2 = AttendeeInfo(attendeeId: "attendeeId2", externalUserId: externalUserId)

        XCTAssertTrue(attendeeInfo1 < attendeeInfo2)
    }
}
