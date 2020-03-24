//
//  VideoClientState.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

enum VideoClientState: Int32 {
    case uninitialized = -1
    case initialized = 0
    case started = 1
    case stopped = 2
}
