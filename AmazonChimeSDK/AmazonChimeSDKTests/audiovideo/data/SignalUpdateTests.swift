//
//  SignalUpdateTests.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

@testable import AmazonChimeSDK
import XCTest

class SignalUpdateTests: XCTestCase {
    private let attendeeInfo = AttendeeInfo(attendeeId: "attendeeId", externalUserId: "externalUserId")
    private let signalStrength = SignalStrength.none

    func testVolumeUpdateShouldBeInitialized() {
        let signalUpdate = SignalUpdate(attendeeInfo: attendeeInfo, signalStrength: signalStrength)
        XCTAssertEqual(attendeeInfo, signalUpdate.attendeeInfo)
        XCTAssertEqual(signalStrength, signalUpdate.signalStrength)
    }
}
