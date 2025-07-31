//
//  PermissionError.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objc public enum DeviceError: Int, Error, CustomStringConvertible {
    case audioPermissionError
    case videoPermissionError
    case audioInputDeviceNotRespondingError
    case audioOutputDeviceNotRespondingError
    case noCameraSelected
    case noAvailableAudioInputs

    public var description: String {
        switch self {
        case .audioPermissionError:
            return "audioPermissionError"
        case .videoPermissionError:
            return "videoPermissionError"
        case .audioInputDeviceNotRespondingError:
            return "audioInputDeviceNotRespondingError"
        case .audioOutputDeviceNotRespondingError:
            return "audioOutputDeviceNotRespondingError"
        case .noCameraSelected:
            return "noCameraSelected"
        case .noAvailableAudioInputs:
            return "noAvailableAudioInputs"
        }
    }
}
