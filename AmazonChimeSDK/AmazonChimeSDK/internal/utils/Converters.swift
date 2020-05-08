//
//  Converters.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AmazonChimeSDKMedia

@objcMembers class Converters: NSObject {
    enum AudioClientStatus {
        static func toMeetingSessionStatusCode(rawValue: UInt32) -> MeetingSessionStatusCode {
            return MeetingSessionStatusCode(rawValue: rawValue) ?? .unknown
        }

        static func toMeetingSessionStatusCode(status: audio_client_status_t) -> MeetingSessionStatusCode {
            return Self.toMeetingSessionStatusCode(rawValue: status.rawValue)
        }
    }

    enum AudioClientState {
        static func toSessionStateControllerAction(state: audio_client_state_t) -> SessionStateControllerAction {
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
    }
}
