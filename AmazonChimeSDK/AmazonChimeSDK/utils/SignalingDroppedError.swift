//
//  SignalingDroppedError.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AmazonChimeSDKMedia

@objc public enum SignalingDroppedError: Int, Error, CustomStringConvertible {
    case none
    case signalingClientDisconnected
    case signalingClientClosed
    case signalingClientEOF
    case signalingClientError
    case signalingClientProxyError
    case signalingClientOpenFailed
    case signalFrameParseFailed
    case signalFrameSerializeFailed
    case signalFrameSendingFailed
    case internalServerError
    case other
    
    public init(from videoClientError: video_client_signaling_dropped_error) {
        switch videoClientError {
        case VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_NONE:
            self = .none
        case VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_SIGNALING_CLIENT_DISCONNECTED:
            self = .signalingClientDisconnected
        case VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_SIGNALING_CLIENT_CLOSED:
            self = .signalingClientClosed
        case VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_SIGNALING_CLIENT_EOF:
            self = .signalingClientEOF
        case VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_SIGNALING_CLIENT_ERROR:
            self = .signalingClientError
        case VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_SIGNALING_CLIENT_PROXY_ERROR:
            self = .signalingClientProxyError
        case VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_SIGNALING_CLIENT_OPEN_FAILED:
            self = .signalingClientOpenFailed
        case VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_SIGNAL_FRAME_PARSE_FAILED:
            self = .signalFrameParseFailed
        case VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_SIGNAL_FRAME_SERIALIZE_FAILED:
            self = .signalFrameSerializeFailed
        case VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_VIDEO_SIGNAL_FRAME_SENDING_FAILED:
            self = .signalFrameSendingFailed
        case VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_INTERNAL_SERVER_ERROR:
            self = .internalServerError
        default:
            self = .other
        }
    }

    public var description: String {
        switch self {
        case .none:
            return "none"
        case .signalingClientDisconnected:
            return "signalingClientDisconnected"
        case .signalingClientClosed:
            return "signalingClientClosed"
        case .signalingClientEOF:
            return "signalingClientEOF"
        case .signalingClientError:
            return "signalingClientError"
        case .signalingClientProxyError:
            return "signalingClientProxyError"
        case .signalingClientOpenFailed:
            return "signalingClientOpenFailed"
        case .signalFrameParseFailed:
            return "signalFrameParseFailed"
        case .signalFrameSerializeFailed:
            return "signalFrameSerializeFailed"
        case .signalFrameSendingFailed:
            return "signalFrameSendingFailed"
        case .internalServerError:
            return "internalServerError"
        case .other:
            return "other"
        }
    }
}
