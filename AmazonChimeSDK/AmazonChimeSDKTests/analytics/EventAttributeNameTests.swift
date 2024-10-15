//
//  EventAttributeNameTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
@testable import AmazonChimeSDK
import XCTest

class EventAttributeNameTests: XCTestCase {
    func testDescriptionShouldMatch() {
        XCTAssertEqual(EventAttributeName.deviceName.description, "deviceName")
        XCTAssertEqual(EventAttributeName.deviceManufacturer.description, "deviceManufacturer")
        XCTAssertEqual(EventAttributeName.deviceModel.description, "deviceModel")
        XCTAssertEqual(EventAttributeName.osName.description, "osName")
        XCTAssertEqual(EventAttributeName.osVersion.description, "osVersion")
        XCTAssertEqual(EventAttributeName.sdkName.description, "sdkName")
        XCTAssertEqual(EventAttributeName.sdkVersion.description, "sdkVersion")
        XCTAssertEqual(EventAttributeName.timestampMs.description, "timestampMs")
        XCTAssertEqual(EventAttributeName.mediaSdkVersion.description, "mediaSdkVersion")
        XCTAssertEqual(EventAttributeName.attendeeId.description, "attendeeId")
        XCTAssertEqual(EventAttributeName.externalMeetingId.description, "externalMeetingId")
        XCTAssertEqual(EventAttributeName.externalUserId.description, "externalUserId")
        XCTAssertEqual(EventAttributeName.meetingId.description, "meetingId")
        XCTAssertEqual(EventAttributeName.meetingHistory.description, "meetingHistory")
        XCTAssertEqual(EventAttributeName.maxVideoTileCount.description, "maxVideoTileCount")
        XCTAssertEqual(EventAttributeName.meetingStartDurationMs.description, "meetingStartDurationMs")
        XCTAssertEqual(EventAttributeName.meetingDurationMs.description, "meetingDurationMs")
        XCTAssertEqual(EventAttributeName.meetingErrorMessage.description, "meetingErrorMessage")
        XCTAssertEqual(EventAttributeName.meetingStatus.description, "meetingStatus")
        XCTAssertEqual(EventAttributeName.poorConnectionCount.description, "poorConnectionCount")
        XCTAssertEqual(EventAttributeName.retryCount.description, "retryCount")
        XCTAssertEqual(EventAttributeName.videoInputError.description, "videoInputError")
    }
}
