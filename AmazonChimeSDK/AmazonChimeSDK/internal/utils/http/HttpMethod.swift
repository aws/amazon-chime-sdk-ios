//
//  HttpMethod.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

enum HttpMethod: String, CustomStringConvertible {
    case post
    case put
    case get
    case delete
    
    public var description: String {
        switch self {
        case .post:
            return "post"
        case .put:
            return "put"
        case .get:
            return "get"
        case .delete:
            return "delete"
        }
    }
}
