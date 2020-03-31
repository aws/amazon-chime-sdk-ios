//
//  SignalUpdateTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
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
