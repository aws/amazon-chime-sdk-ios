//
//  VoiceFocusError.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AmazonChimeSDKMedia

@objc public enum VoiceFocusError: Int, Error, CustomStringConvertible {
    
    case audioClientNotStarted
    case audioClientError
    case setParamFailed
    case notInitialized
    case other
    
    public init(from xalError: Int) {
        switch xalError {
        case 1:
            self = .audioClientError
        case 6:
            self = .notInitialized
        case 19:
            self = .setParamFailed
        default:
            self = .other
        }
    }

    public var description: String {
        switch self {
        case .audioClientNotStarted:
            return "audioClientNotStarted"
        case .audioClientError:
            return "audioClientError"
        case .notInitialized:
            return "notInitialized"
        case .setParamFailed:
            return "setParamFailed"
        case .other:
            return "other"
        }
    }
}
