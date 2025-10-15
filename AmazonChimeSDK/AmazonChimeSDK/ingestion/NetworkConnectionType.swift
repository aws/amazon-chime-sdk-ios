//
//  NetworkConnectionType.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Network

@objc public enum NetworkConnectionType: Int, CustomStringConvertible {
    /// WiFi connection
    case wifi
    /// Cellular connection
    case cellular
    /// Wired ethernet connection
    case wiredEthernet
    /// Other connection type
    case other
    /// No network connection available
    case none
    /// Network connection type cannot be determined
    case unknown
    
    public init(from path: NWPath) {
        if path.status != .satisfied {
            self = .none
            return
        }
        
        if path.usesInterfaceType(.wifi) {
            self = .wifi
        } else if path.usesInterfaceType(.cellular) {
            self = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            self = .wiredEthernet
        } else if path.usesInterfaceType(.other) {
            self = .other
        } else {
            self = .unknown
        }
    }
    
    public var description: String {
        switch self {
        case .wifi:
            return "Wifi"
        case .cellular:
            return "Cellular"
        case .wiredEthernet:
            return "Ethernet"
        case .other:
            return "Other"
        case .none:
            return "None"
        case .unknown:
            return "Unknown"
        }
    }
}
