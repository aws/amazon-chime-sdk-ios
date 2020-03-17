//
//  VolumeUpdateTests.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

@testable import AmazonChimeSDK
import XCTest

class VolumeUpdateTests: XCTestCase {
    private let attendeeInfo = AttendeeInfo(attendeeId: "attendeeId", externalUserId: "externalUserId")
    private let volumeLevel = VolumeLevel.muted

    func testVolumeUpdateShouldBeInitialized() {
        let volumeUpdate = VolumeUpdate(attendeeInfo: attendeeInfo, volumeLevel: volumeLevel)
        XCTAssertEqual(attendeeInfo, volumeUpdate.attendeeInfo)
        XCTAssertEqual(volumeLevel, volumeUpdate.volumeLevel)
    }
}
