//
//  AppState.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import UIKit

@objc public enum AppState: Int, CustomStringConvertible {
    case active
    case inactive
    case foreground
    case background
    case terminated
    case other
    
    public init(from applicationState: UIApplication.State) {
        switch applicationState {
        case .active:
            self = .active
        case .inactive:
            self = .inactive
        case .background:
            self = .background
        @unknown default:
            self = .other
        }
    }
    
    public var description: String {
        switch self {
        case .active:
            return "Active"
        case .inactive:
            return "Inactive"
        case .foreground:
            return "Foreground"
        case .background:
            return "Background"
        case .terminated:
            return "Terminated"
        case .other:
            return "Other"
        }
    }
}
