//
//  ResourceError.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objc public enum ResourceError: Int, Error, CustomStringConvertible {
    case notFound

    public var description: String {
        switch self {
        case .notFound:
            return "notFound"
        }
    }
}
