//
//  MediaError.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objc public enum MediaError: Int, Error, CustomStringConvertible {
    case illegalState
    case audioFailedToStart
    case noCameraSelected
    case noAudioDevices
    case overrideOutputAudioPortFailed
    case setPreferredAudioInputFailed

    public var description: String {
        switch self {
        case .illegalState:
            return "illegalState"
        case .audioFailedToStart:
            return "audioFailedToStart"
        case .noCameraSelected:
            return "noCameraSelected"
        case .noAudioDevices:
            return "noAudioDevices"
        case .overrideOutputAudioPortFailed:
            return "overrideOutputAudioPortFailed"
        case .setPreferredAudioInputFailed:
            return "setPreferredAudioInputFailed"
        }
    }
}
