//
//  VideoClientState.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objc enum VideoClientState: Int32 {
    case uninitialized = -1
    case initialized = 0
    case started = 1
    case stopped = 2

    var description: String {
        switch self {
        case .uninitialized:
            return "uninitialized"
        case .initialized:
            return "initialized"
        case .started:
            return "started"
        case .stopped:
            return "stopped"
        }
    }
}
