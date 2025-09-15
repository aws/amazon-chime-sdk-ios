//
//  VideoClientFailedError.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AmazonChimeSDKMedia

@objc public enum VideoClientFailedError: Int, Error, CustomStringConvertible {

    case authenticationFailed
    case peerConnectionCreateFailed
    case maxRetryPeriodExceeded
    case other
    
    public init(from videoClientStatus: video_client_status_t) {
        switch videoClientStatus {
        case VIDEO_CLIENT_ERR_PROXY_AUTHENTICATION_FAILED:
            self = .authenticationFailed
        case VIDEO_CLIENT_ERR_PEERCONN_CREATE_FAILED:
            self = .peerConnectionCreateFailed
        case VIDEO_CLIENT_ERR_MAX_RETRY_PERIOD_EXCEEDED:
            self = .maxRetryPeriodExceeded
        default:
            self = .other
        }
    }

    public var description: String {
        switch self {
        case .authenticationFailed:
            return "authenticationFailed"
        case .peerConnectionCreateFailed:
            return "peerConnectionCreateFailed"
        case .maxRetryPeriodExceeded:
            return "maxRetryPeriodExceeded"
        case .other:
            return "other"
        }
    }
}
