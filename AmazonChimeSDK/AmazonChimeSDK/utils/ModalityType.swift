//
//  ModalityType.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objc public enum ModalityType: Int, Error, CustomStringConvertible {
    case content

    public var description: String {
        switch self {
        case .content:
            return "content"
        }
    }
}
