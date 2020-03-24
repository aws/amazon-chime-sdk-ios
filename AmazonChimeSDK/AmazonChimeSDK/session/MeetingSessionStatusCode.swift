//
//  MeetingSessionStatusCode.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objc public enum MeetingSessionStatusCode: UInt32, CustomStringConvertible {
    /// Everything is OK so far.
    case ok = 0

    /// The audio leg failed.
    case audioDisconnected = 9

    /// Due to connection health a reconnect has been triggered.
    case connectionHealthReconnect = 10

    /// Network is not good enough for VoIP.
    case networkBecomePoor = 59

    /// Server hung up.
    case audioServerHungup = 60

    /// The attendee joined from another device.
    case audioJoinedFromAnotherDevice = 61

    /// There was an internal server error with the audio leg.
    case audioInternalServerError = 62

    /// Authentication was rejected. The client is not allowed on this call.
    case audioAuthenticationRejected = 63

    /// The client can not join because the call is at capacity.
    case audioCallAtCapacity = 64

    /// Could not connect the audio leg due to the service being unavailable.
    case audioServiceUnavailable = 65

    /// The attendee should explicitly switch itself from joined with audio to checked-in.
    case audioDisconnectAudio = 69

    /// The call was ended.
    case audioCallEnded = 75

    /// video service is unavailable.
    case videoServiceUnavailable = 12

    /// If State cannot be parsed, then use this state.
    case unknown = 78

    /// When maximum concurrent video channel reached
    case videoAtCapacityViewOnly = 206

    public var description: String {
        switch self {
        case .ok:
            return "ok"
        case .audioDisconnected:
            return "audioDisconnected"
        case .connectionHealthReconnect:
            return "connectionHealthReconnect"
        case .networkBecomePoor:
            return "networkBecomePoor"
        case .audioServerHungup:
            return "audioServerHungup"
        case .audioJoinedFromAnotherDevice:
            return "audioJoinedFromAnotherDevice"
        case .audioInternalServerError:
            return "audioInternalServerError"
        case .audioAuthenticationRejected:
            return "audioAuthenticationRejected"
        case .audioCallAtCapacity:
            return "audioCallAtCapacity"
        case .audioServiceUnavailable:
            return "audioServiceUnavailable"
        case .audioDisconnectAudio:
            return "audioDisconnectAudio"
        case .audioCallEnded:
            return "audioCallEnded"
        case .videoServiceUnavailable:
            return "videoServiceUnavailable"
        case .unknown:
            return "unknown"
        case .videoAtCapacityViewOnly:
            return "videoAtCapacityViewOnly"
        }
    }
}
