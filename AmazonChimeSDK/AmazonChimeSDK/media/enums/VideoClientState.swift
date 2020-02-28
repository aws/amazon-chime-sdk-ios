//
//  VideoClientState.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

enum VideoClientState: Int32 {
    case uninitialized = -1
    case initialized = 0
    case started = 1
    case stopped = 2
}
