//
//  MeetingSessionStatusCodeTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import XCTest

class MeetingSessionStatusCodeTests: XCTestCase {
    func testDescriptionShouldMatch() {
        XCTAssertEqual(MeetingSessionStatusCode.ok.description, "ok")
        XCTAssertEqual(MeetingSessionStatusCode.audioDisconnected.description, "audioDisconnected")
        XCTAssertEqual(MeetingSessionStatusCode.connectionHealthReconnect.description, "connectionHealthReconnect")
        XCTAssertEqual(MeetingSessionStatusCode.networkBecomePoor.description, "networkBecomePoor")
        XCTAssertEqual(MeetingSessionStatusCode.audioServerHungup.description, "audioServerHungup")
        XCTAssertEqual(MeetingSessionStatusCode.audioJoinedFromAnotherDevice.description,
                       "audioJoinedFromAnotherDevice")
        XCTAssertEqual(MeetingSessionStatusCode.audioInternalServerError.description, "audioInternalServerError")
        XCTAssertEqual(MeetingSessionStatusCode.audioAuthenticationRejected.description, "audioAuthenticationRejected")
        XCTAssertEqual(MeetingSessionStatusCode.audioCallAtCapacity.description, "audioCallAtCapacity")
        XCTAssertEqual(MeetingSessionStatusCode.audioServiceUnavailable.description, "audioServiceUnavailable")
        XCTAssertEqual(MeetingSessionStatusCode.audioDisconnectAudio.description, "audioDisconnectAudio")
        XCTAssertEqual(MeetingSessionStatusCode.audioCallEnded.description, "audioCallEnded")
        XCTAssertEqual(MeetingSessionStatusCode.videoServiceUnavailable.description, "videoServiceUnavailable")
        XCTAssertEqual(MeetingSessionStatusCode.unknown.description, "unknown")
        XCTAssertEqual(MeetingSessionStatusCode.videoAtCapacityViewOnly.description, "videoAtCapacityViewOnly")
    }
}
