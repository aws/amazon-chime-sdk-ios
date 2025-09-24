//
//  Converters.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDKMedia
import Foundation

@objcMembers class Converters: NSObject {
    enum AudioClientStatus {
        static func toMeetingSessionStatusCode(rawValue: UInt32) -> MeetingSessionStatusCode {
            return MeetingSessionStatusCode(rawValue: rawValue) ?? .unknown
        }

        static func toMeetingSessionStatusCode(status: audio_client_status_t) -> MeetingSessionStatusCode {
            return Self.toMeetingSessionStatusCode(rawValue: status.rawValue)
        }
    }
    enum MeetingEventName {
        static func toMeetingHistoryEventName(name: EventName) -> MeetingHistoryEventName {
            switch name {
            case .audioInputFailed:
                return .audioInputFailed
            case .videoInputFailed:
                return .videoInputFailed
            case .meetingStartRequested:
                return .meetingStartRequested
            case .meetingStartSucceeded:
                return .meetingStartSucceeded
            case .meetingReconnected:
                return .meetingReconnected
            case .meetingStartFailed:
                return .meetingStartFailed
            case .meetingFailed:
                return .meetingFailed
            case .meetingEnded:
                return .meetingEnded
            case .videoClientSignalingDropped:
                return .videoClientSignalingDropped
            case .contentShareSignalingDropped:
                return .contentShareSignalingDropped
            case .contentShareStartRequested:
                return .contentShareStartRequested
            case .contentShareStarted:
                return .contentShareStarted
            case .contentShareStopped:
                return .contentShareStopped
            case .contentShareFailed:
                return .contentShareFailed
            case .appStateChanged:
                return .appStateChanged
            case .appMemoryLow:
                return .appMemoryLow
            case .unknown:
                return .unknown
            }
        }
    }

    enum AudioClientState {
        static func toSessionStateControllerAction(state: audio_client_state_t, status: MeetingSessionStatusCode) -> SessionStateControllerAction {
            if (shouldCloseAndNotifyEndMeeting(status: status)) {
                return .finishDisconnecting
            }
            switch state {
            case AUDIO_CLIENT_STATE_UNKNOWN:
                return .unknown
            case AUDIO_CLIENT_STATE_INIT:
                return .initialize
            case AUDIO_CLIENT_STATE_CONNECTING:
                return .connecting
            case AUDIO_CLIENT_STATE_CONNECTED:
                return .finishConnecting
            case AUDIO_CLIENT_STATE_RECONNECTING:
                return .reconnecting
            case AUDIO_CLIENT_STATE_DISCONNECTING:
                return .disconnecting
            case AUDIO_CLIENT_STATE_DISCONNECTED_NORMAL:
                return .finishDisconnecting
            case AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL,
                 AUDIO_CLIENT_STATE_SERVER_HUNGUP,
                 AUDIO_CLIENT_STATE_FAILED_TO_CONNECT:
                return .fail
            default:
                return .unknown
            }
        }
        
        static func shouldCloseAndNotifyEndMeeting(status: MeetingSessionStatusCode) -> Bool {
            return status == MeetingSessionStatusCode.audioServerHungup || status == MeetingSessionStatusCode.audioJoinedFromAnotherDevice
        }
    }

    enum Transcript {
        static func toTranscriptionStatusType(type: TranscriptionStatusTypeInternal) -> TranscriptionStatusType {
            return TranscriptionStatusType(rawValue: type.rawValue) ?? .unknown
        }

        static func toTranscriptItemType(type: TranscriptItemTypeInternal) -> TranscriptItemType {
            return TranscriptItemType(rawValue: type.rawValue) ?? .unknown
        }

        static func toAttendeeInfo(attendeeInfo: AttendeeInfoInternal) -> AttendeeInfo {
            return AttendeeInfo(attendeeId: attendeeInfo.attendeeId, externalUserId: attendeeInfo.externalUserId)
        }
    }
}
