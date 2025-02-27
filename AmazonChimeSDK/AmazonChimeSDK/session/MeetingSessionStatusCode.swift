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

    /// There was an internal server error related to audio. This may indicate some issue with the audio device, or an issue with the Amazon Chime SDK service itself.
    case audioDisconnected = 9

    /// Due to connection health a reconnect has been triggered.
    case connectionHealthReconnect = 10

    /// Network is not good enough for VoIP, `AudioVideoObserver.audioSessionDidDrop()` will be triggered, and there will be an automatic attempt of reconnecting.
    /// If the reconnecting is successful, `audioSessionDidStart(reconnecting:)` will be called with value of `reconnecting` as `true`.
    case networkBecomePoor = 59

    /// Chime SDK audio server hung up.
    case audioServerHungup = 60

    /// The attendee joined from another device.
    case audioJoinedFromAnotherDevice = 61

    /// There was an internal server error related to audio. This may indicate some issue with the audio device, or an issue with the Amazon Chime SDK service itself
    case audioInternalServerError = 62

    /// Authentication was rejected as the attendee information in MeetingSessionCredentials did not match that of an attendee created via chime::CreateAttendee.
    /// This error may imply an issue with your credential providing service, the client will not be allowed on this call.
    case audioAuthenticationRejected = 63

    /// The client can not join because the meeting is at capacity. The service supports up to 250 attendees.
    case audioCallAtCapacity = 64

    /// There was an internal server error related to audio. This may indicate some issue with the audio device, or an issue with the Amazon Chime SDK service itself.
    case audioServiceUnavailable = 65

    /// The attendee should explicitly switch itself from joined with audio to checked-in.
    case audioDisconnectAudio = 69

    /// The attendee attempted to join a meeting that has already ended.
    /// See this [FAQ](https://aws.github.io/amazon-chime-sdk-js/modules/faqs.html#when-does-an-amazon-chime-sdk-meeting-end)
    /// for more information. The end user may want to be notified of this type of error.
    case audioCallEnded = 75

    /// There was an internal server error related to video. This may indicate some issue with the video device, or an issue with the Amazon Chime SDK service itself.
    case videoServiceUnavailable = 12

    /// The meeting session is in unkown status.
    case unknown = 78

    /// The video client has tried to send video but was unable to do so due to capacity reached. However, the video client can still receive remote video streams.
    case videoAtCapacityViewOnly = 206

    /// Designated input device is not responding and timed out.
    case audioInputDeviceNotResponding = 82

    /// Designated output device is not responding and timed out.
    case audioOutputDeviceNotResponding = 83

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
        case .audioInputDeviceNotResponding:
            return "audioInputDeviceNotResponding"
        case .audioOutputDeviceNotResponding:
            return "audioOutputDeviceNotResponding"
        }
    }
}
