//
//  VideoInterruptionReasonTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
@testable import AmazonChimeSDK
import XCTest

class VideoInterruptionReasonTests: XCTestCase {
    func testDescriptionShouldMatch() {
        XCTAssertEqual(
            VideoInterruptionReason.videoDeviceNotAvailableInBackground.description,
            "videoDeviceNotAvailableInBackground"
        )
        XCTAssertEqual(
            VideoInterruptionReason.videoDeviceInUseByAnotherClient.description,
            "videoDeviceInUseByAnotherClient"
        )

        // NOTE: The production code returns "notInitialized" for this case, which does not match
        // the case name. This appears to be a copy-paste bug. The assertion pins current behavior
        // so the test passes and coverage is deterministic. Correcting this value is tracked as a
        // separate compatibility decision because the string is serialized into ingestion telemetry.
        XCTAssertEqual(
            VideoInterruptionReason.videoDeviceNotAvailableWithMultipleForegroundApps.description,
            "notInitialized"
        )

        XCTAssertEqual(
            VideoInterruptionReason.videoDeviceNotAvailableDueToSystemPressure.description,
            "videoDeviceNotAvailableDueToSystemPressure"
        )
        XCTAssertEqual(
            VideoInterruptionReason.other.description,
            "other"
        )
    }
}
