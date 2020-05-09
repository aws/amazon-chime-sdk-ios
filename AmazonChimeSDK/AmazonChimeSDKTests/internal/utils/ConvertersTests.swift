//
//  ConvertersTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import AmazonChimeSDKMedia
import XCTest

class ConvertersTests: XCTestCase {
    func testAudioClientStatusToMeetingSessionStatusCode() {
        XCTAssertEqual(
            Converters.AudioClientStatus.toMeetingSessionStatusCode(status: AUDIO_CLIENT_OK),
            MeetingSessionStatusCode.ok
        )
        XCTAssertEqual(
            Converters.AudioClientStatus.toMeetingSessionStatusCode(status: AUDIO_CLIENT_ERR_SERVER_HUNGUP),
            MeetingSessionStatusCode.audioServerHungup
        )
        XCTAssertEqual(
            Converters.AudioClientStatus.toMeetingSessionStatusCode(
                status: AUDIO_CLIENT_ERR_JOINED_FROM_ANOTHER_DEVICE
            ),
            MeetingSessionStatusCode.audioJoinedFromAnotherDevice
        )
        XCTAssertEqual(
            Converters.AudioClientStatus.toMeetingSessionStatusCode(status: AUDIO_CLIENT_ERR_INTERNAL_SERVER_ERROR),
            MeetingSessionStatusCode.audioInternalServerError
        )
        XCTAssertEqual(
            Converters.AudioClientStatus.toMeetingSessionStatusCode(status: AUDIO_CLIENT_ERR_AUTH_REJECTED),
            MeetingSessionStatusCode.audioAuthenticationRejected
        )
        XCTAssertEqual(
            Converters.AudioClientStatus.toMeetingSessionStatusCode(status: AUDIO_CLIENT_ERR_CALL_AT_CAPACITY),
            MeetingSessionStatusCode.audioCallAtCapacity
        )
        XCTAssertEqual(
            Converters.AudioClientStatus.toMeetingSessionStatusCode(status: AUDIO_CLIENT_ERR_SERVICE_UNAVAILABLE),
            MeetingSessionStatusCode.audioServiceUnavailable
        )
        XCTAssertEqual(
            Converters.AudioClientStatus.toMeetingSessionStatusCode(status: AUDIO_CLIENT_ERR_SHOULD_DISCONNECT_AUDIO),
            MeetingSessionStatusCode.audioDisconnectAudio
        )
        XCTAssertEqual(
            Converters.AudioClientStatus.toMeetingSessionStatusCode(status: AUDIO_CLIENT_ERR_CALL_ENDED),
            MeetingSessionStatusCode.audioCallEnded
        )
        XCTAssertEqual(
            Converters.AudioClientStatus.toMeetingSessionStatusCode(status: AUDIO_CLIENT_STATUS_ENUM_END),
            MeetingSessionStatusCode.unknown
        )
    }

    func testAudioClientStatusRawValueToMeetingSessionStatusCode() {
        XCTAssertEqual(
            Converters.AudioClientStatus.toMeetingSessionStatusCode(rawValue: AUDIO_CLIENT_OK.rawValue),
            MeetingSessionStatusCode.ok
        )
        XCTAssertEqual(
            Converters.AudioClientStatus.toMeetingSessionStatusCode(rawValue: AUDIO_CLIENT_ERR_SERVER_HUNGUP.rawValue),
            MeetingSessionStatusCode.audioServerHungup
        )
        XCTAssertEqual(
            Converters.AudioClientStatus.toMeetingSessionStatusCode(
                rawValue: AUDIO_CLIENT_ERR_JOINED_FROM_ANOTHER_DEVICE.rawValue
            ),
            MeetingSessionStatusCode.audioJoinedFromAnotherDevice
        )
        XCTAssertEqual(
            Converters.AudioClientStatus.toMeetingSessionStatusCode(
                rawValue: AUDIO_CLIENT_ERR_INTERNAL_SERVER_ERROR.rawValue
            ),
            MeetingSessionStatusCode.audioInternalServerError
        )
        XCTAssertEqual(
            Converters.AudioClientStatus.toMeetingSessionStatusCode(
                rawValue: AUDIO_CLIENT_ERR_AUTH_REJECTED.rawValue
            ),
            MeetingSessionStatusCode.audioAuthenticationRejected
        )
        XCTAssertEqual(
            Converters.AudioClientStatus.toMeetingSessionStatusCode(
                rawValue: AUDIO_CLIENT_ERR_CALL_AT_CAPACITY.rawValue
            ),
            MeetingSessionStatusCode.audioCallAtCapacity
        )
        XCTAssertEqual(
            Converters.AudioClientStatus.toMeetingSessionStatusCode(
                rawValue: AUDIO_CLIENT_ERR_SERVICE_UNAVAILABLE.rawValue
            ),
            MeetingSessionStatusCode.audioServiceUnavailable
        )
        XCTAssertEqual(
            Converters.AudioClientStatus.toMeetingSessionStatusCode(
                rawValue: AUDIO_CLIENT_ERR_SHOULD_DISCONNECT_AUDIO.rawValue
            ),
            MeetingSessionStatusCode.audioDisconnectAudio
        )
        XCTAssertEqual(
            Converters.AudioClientStatus.toMeetingSessionStatusCode(
                rawValue: AUDIO_CLIENT_ERR_CALL_ENDED.rawValue
            ),
            MeetingSessionStatusCode.audioCallEnded
        )
        XCTAssertEqual(
            Converters.AudioClientStatus.toMeetingSessionStatusCode(
                rawValue: AUDIO_CLIENT_STATUS_ENUM_END.rawValue
            ),
            MeetingSessionStatusCode.unknown
        )
    }

    func testAudioClientStateToSessionStateControllerAction() {
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_UNKNOWN),
            SessionStateControllerAction.unknown
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_INIT),
            SessionStateControllerAction.initialize
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_CONNECTING),
            SessionStateControllerAction.connecting
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_CONNECTED),
            SessionStateControllerAction.finishConnecting
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_RECONNECTING),
            SessionStateControllerAction.reconnecting
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_DISCONNECTING),
            SessionStateControllerAction.disconnecting
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_DISCONNECTED_NORMAL),
            SessionStateControllerAction.finishDisconnecting
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL),
            SessionStateControllerAction.fail
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_SERVER_HUNGUP),
            SessionStateControllerAction.fail
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_FAILED_TO_CONNECT),
            SessionStateControllerAction.fail
        )
    }
}
