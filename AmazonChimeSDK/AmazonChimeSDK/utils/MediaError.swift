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

    public var description: String {
        switch self {
        case .illegalState:
            return "illegalState"
        case .audioFailedToStart:
            return "audioFailedToStart"
        }
    }
}
