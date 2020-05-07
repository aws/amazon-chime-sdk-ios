//
//  MediaError.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objc public enum MediaError: Int, Error, CustomStringConvertible {
    case audioUninitializedState
    case audioStartedState
    case audioStoppingState

    public var description: String {
        switch self {
        case .audioUninitializedState:
            return "audioUninitializedState"
        case .audioStartedState:
            return "audioStartedState"
        case .audioStoppingState:
            return "audioStoppingState"
        }
    }
}
