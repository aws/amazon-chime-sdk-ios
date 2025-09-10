//
//  BatteryState.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import UIKit

@objc public enum BatteryState: Int, CustomStringConvertible {
    /// The device is plugged into power and the battery is charging
    case charging
    /// The device is unplugged and running on battery power
    case discharging
    /// The device is plugged into power and the battery is fully charged
    case full
    /// The battery state cannot be determined (battery monitoring may be disabled)
    case unknown
    
    public init(from batteryState: UIDevice.BatteryState) {
        switch batteryState {
        case .charging:
            self = .charging
        case .unplugged:
            self = .discharging
        case .full:
            self = .full
        case .unknown:
            self = .unknown
        @unknown default:
            self = .unknown
        }
    }
    
    public var description: String {
        switch self {
        case .charging:
            return "Charging"
        case .discharging:
            return "Discharging"
        case .full:
            return "Full"
        case .unknown:
            return "Unknown"
        }
    }
}
