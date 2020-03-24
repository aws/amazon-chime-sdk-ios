//
//  PermissionError.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objc public enum PermissionError: Int, Error, CustomStringConvertible {
    case audioPermissionError
    case videoPermissionError

    public var description: String {
        switch self {
        case .audioPermissionError:
            return "audioPermissionError"
        case .videoPermissionError:
            return "videoPermissionError"
        }
    }
}
