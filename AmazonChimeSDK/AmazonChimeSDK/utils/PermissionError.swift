//
//  PermissionError.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
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
