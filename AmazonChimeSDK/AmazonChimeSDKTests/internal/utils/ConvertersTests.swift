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
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_UNKNOWN, status: MeetingSessionStatusCode.ok),
            SessionStateControllerAction.unknown
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_INIT, status: MeetingSessionStatusCode.ok),
            SessionStateControllerAction.initialize
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_CONNECTING, status: MeetingSessionStatusCode.ok),
            SessionStateControllerAction.connecting
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_CONNECTED, status: MeetingSessionStatusCode.ok),
            SessionStateControllerAction.finishConnecting
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_RECONNECTING, status: MeetingSessionStatusCode.ok),
            SessionStateControllerAction.reconnecting
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_DISCONNECTING, status: MeetingSessionStatusCode.ok),
            SessionStateControllerAction.disconnecting
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_DISCONNECTED_NORMAL, status: MeetingSessionStatusCode.ok),
            SessionStateControllerAction.finishDisconnecting
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL, status: MeetingSessionStatusCode.ok),
            SessionStateControllerAction.fail
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_SERVER_HUNGUP, status: MeetingSessionStatusCode.ok),
            SessionStateControllerAction.fail
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_FAILED_TO_CONNECT, status: MeetingSessionStatusCode.ok),
            SessionStateControllerAction.fail
        )

        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_UNKNOWN, status: MeetingSessionStatusCode.audioServerHungup),
            SessionStateControllerAction.finishDisconnecting
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_INIT, status: MeetingSessionStatusCode.audioServerHungup),
            SessionStateControllerAction.finishDisconnecting
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_CONNECTING, status: MeetingSessionStatusCode.audioServerHungup),
            SessionStateControllerAction.finishDisconnecting
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_CONNECTED, status: MeetingSessionStatusCode.audioServerHungup),
            SessionStateControllerAction.finishDisconnecting
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_RECONNECTING, status: MeetingSessionStatusCode.audioServerHungup),
            SessionStateControllerAction.finishDisconnecting
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_DISCONNECTING, status: MeetingSessionStatusCode.audioServerHungup),
            SessionStateControllerAction.finishDisconnecting
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_DISCONNECTED_NORMAL, status: MeetingSessionStatusCode.audioServerHungup),
            SessionStateControllerAction.finishDisconnecting
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL, status: MeetingSessionStatusCode.audioServerHungup),
            SessionStateControllerAction.finishDisconnecting
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_SERVER_HUNGUP, status: MeetingSessionStatusCode.audioServerHungup),
            SessionStateControllerAction.finishDisconnecting
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_FAILED_TO_CONNECT, status: MeetingSessionStatusCode.audioServerHungup),
            SessionStateControllerAction.finishDisconnecting
        )

        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_UNKNOWN, status: MeetingSessionStatusCode.audioJoinedFromAnotherDevice),
            SessionStateControllerAction.finishDisconnecting
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_INIT, status: MeetingSessionStatusCode.audioJoinedFromAnotherDevice),
            SessionStateControllerAction.finishDisconnecting
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_CONNECTING, status: MeetingSessionStatusCode.audioJoinedFromAnotherDevice),
            SessionStateControllerAction.finishDisconnecting
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_CONNECTED, status: MeetingSessionStatusCode.audioJoinedFromAnotherDevice),
            SessionStateControllerAction.finishDisconnecting
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_RECONNECTING, status: MeetingSessionStatusCode.audioJoinedFromAnotherDevice),
            SessionStateControllerAction.finishDisconnecting
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_DISCONNECTING, status: MeetingSessionStatusCode.audioJoinedFromAnotherDevice),
            SessionStateControllerAction.finishDisconnecting
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_DISCONNECTED_NORMAL, status: MeetingSessionStatusCode.audioJoinedFromAnotherDevice),
            SessionStateControllerAction.finishDisconnecting
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL, status: MeetingSessionStatusCode.audioJoinedFromAnotherDevice),
            SessionStateControllerAction.finishDisconnecting
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_SERVER_HUNGUP, status: MeetingSessionStatusCode.audioJoinedFromAnotherDevice),
            SessionStateControllerAction.finishDisconnecting
        )
        XCTAssertEqual(
            Converters.AudioClientState.toSessionStateControllerAction(state: AUDIO_CLIENT_STATE_FAILED_TO_CONNECT, status: MeetingSessionStatusCode.audioJoinedFromAnotherDevice),
            SessionStateControllerAction.finishDisconnecting
        )
    }

    func testTranscriptToTranscriptionStatusType() {
        XCTAssertEqual(
            Converters.Transcript.toTranscriptionStatusType(type: TranscriptionStatusTypeInternal.started),
            TranscriptionStatusType.started
        )
        XCTAssertEqual(
            Converters.Transcript.toTranscriptionStatusType(type: TranscriptionStatusTypeInternal.interrupted),
            TranscriptionStatusType.interrupted
        )
        XCTAssertEqual(
            Converters.Transcript.toTranscriptionStatusType(type: TranscriptionStatusTypeInternal.resumed),
            TranscriptionStatusType.resumed
        )
        XCTAssertEqual(
            Converters.Transcript.toTranscriptionStatusType(type: TranscriptionStatusTypeInternal.stopped),
            TranscriptionStatusType.stopped
        )
        XCTAssertEqual(
            Converters.Transcript.toTranscriptionStatusType(type: TranscriptionStatusTypeInternal.failed),
            TranscriptionStatusType.failed
        )
    }

    func testTranscriptToTranscriptItemType() {
        XCTAssertEqual(
            Converters.Transcript.toTranscriptItemType(type: TranscriptItemTypeInternal.pronunciation),
            TranscriptItemType.pronunciation
        )
        XCTAssertEqual(
            Converters.Transcript.toTranscriptItemType(type: TranscriptItemTypeInternal.punctuation),
            TranscriptItemType.punctuation
        )
    }

    func testTranscriptToAttendeeInfo() {
        let attendeeId = "attendee-id"
        let externalUserId = "external-user-id"
        let speakerBefore = AttendeeInfoInternal(attendeeId: attendeeId, externalUserId: externalUserId)!
        let speakerAfter = Converters.Transcript.toAttendeeInfo(attendeeInfo: speakerBefore)
        XCTAssertEqual(speakerAfter.attendeeId, attendeeId)
        XCTAssertEqual(speakerAfter.externalUserId, externalUserId)
    }
    
    func testMeetingEventNameConvertToMatchingHistoryEVentName() {
        XCTAssertEqual(Converters.MeetingEventName.toMeetingHistoryEventName(name: EventName.audioInputFailed),
                       MeetingHistoryEventName.audioInputFailed)
        XCTAssertEqual(Converters.MeetingEventName.toMeetingHistoryEventName(name: EventName.videoInputFailed),
                       MeetingHistoryEventName.videoInputFailed)
        XCTAssertEqual(Converters.MeetingEventName.toMeetingHistoryEventName(name: EventName.meetingStartRequested),
                       MeetingHistoryEventName.meetingStartRequested)
        XCTAssertEqual(Converters.MeetingEventName.toMeetingHistoryEventName(name: EventName.meetingStartSucceeded),
                       MeetingHistoryEventName.meetingStartSucceeded)
        XCTAssertEqual(Converters.MeetingEventName.toMeetingHistoryEventName(name: EventName.meetingReconnected),
                       MeetingHistoryEventName.meetingReconnected)
        XCTAssertEqual(Converters.MeetingEventName.toMeetingHistoryEventName(name: EventName.meetingReconnected),
                       MeetingHistoryEventName.meetingReconnected)
        XCTAssertEqual(Converters.MeetingEventName.toMeetingHistoryEventName(name: EventName.meetingStartFailed),
                       MeetingHistoryEventName.meetingStartFailed)
        XCTAssertEqual(Converters.MeetingEventName.toMeetingHistoryEventName(name: EventName.meetingStartFailed),
                       MeetingHistoryEventName.meetingStartFailed)
        XCTAssertEqual(Converters.MeetingEventName.toMeetingHistoryEventName(name: EventName.meetingFailed),
                       MeetingHistoryEventName.meetingFailed)
        XCTAssertEqual(Converters.MeetingEventName.toMeetingHistoryEventName(name: EventName.unknown),
                       MeetingHistoryEventName.unknown)
    }
}
