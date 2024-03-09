//
//  AudioDeviceCapabilities.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `AudioDeviceCapabilities` describes whether the audio input and output devices are enabled or disabled.
@objc public enum AudioDeviceCapabilities: Int, CaseIterable, CustomStringConvertible {
    /// Disable both the audio input and output devices (i.e. connections to the microphone and speaker devices are not
    /// opened). Muted packets are sent to the server.
    case none = 0

    /// Disable the audio input device and only enable the audio output device (i.e. the connection to the microphone
    /// device is not opened). Muted packets are sent to the server.
    case outputOnly = 1

    /// Enable both the audio input and output devices.
    case inputAndOutput = 2

    public var description: String {
        switch self {
        case .none:
            return "none"
        case .outputOnly:
            return "outputOnly"
        case .inputAndOutput:
            return "inputAndOutput"
        }
    }
}
