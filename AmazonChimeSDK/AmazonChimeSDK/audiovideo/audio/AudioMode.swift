//
//  AudioMode.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `AudioMode` describes the audio mode in which the audio client should operate during a meeting session
@objc public enum AudioMode: Int, CaseIterable, CustomStringConvertible {
    public static var allCases: [AudioMode] = [
        .mono16K,
        .mono48K,
        .stereo48K,
        // .nodevice is not included since it is obsolete
    ]
    
    public init?(rawValue: Int) {
        switch rawValue {
        case 1: self = .mono16K
        case 2: self = .mono48K
        case 3: self = .stereo48K
        // .nodevice is not included since it is obsolete
        default: return nil
        }
    }
    
    /// The mono audio mode with single audio channel and 16KHz sampling rate, for both speaker and microphone.
    case mono16K = 1

    /// The mono audio mode with single audio channel and 48KHz sampling rate, for both speaker and microphone.
    case mono48K = 2

    /// The stereo audio mode with two audio channels for speaker, and single audio channel for microphone, both with 48KHz sampling rate.
    case stereo48K = 3

    /// The `nodevice` audio mode is obsolete. and is replaced by `AudioDeviceCapabilities.none`. To achieve the same functionality as `nodevice`, pass
    /// `AudioDeviceCapabilities.none` into the `AudioVideoConfiguration` constructor instead, e.g. `AudioVideoConfiguration(audioDeviceCapabilities: .none)`
    @available(swift, obsoleted: 1, message: """
    To achieve the same functionality as .nodevice, pass AudioDeviceCapabilities.none into the
    AudioVideoConfiguration constructor instead, e.g. AudioVideoConfiguration(audioDeviceCapabilities: .none)
    """)
    case nodevice = 4

    public var description: String {
        switch self {
        case .mono16K:
            return "mono16K"
        case .mono48K:
            return "mono48K"
        case .stereo48K:
            return "stereo48K"
        }
    }
}
