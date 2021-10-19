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
    /// There will be no audio through mic and speaker
    case noAudio = 0

    /// The default audio mode with single audio channel
    case mono = 1

    public var description: String {
        switch self {
        case .noAudio:
            return "noAudio"
        case .mono:
            return "mono"
        }
    }
}
