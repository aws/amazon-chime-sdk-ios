//
//  MediaDeviceType.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objc public enum MediaDeviceType: Int, CustomStringConvertible {
    case audioBluetooth
    case audioWiredHeadset
    case audioBuiltInSpeaker
    case audioHandset
    case videoFrontCamera
    case videoBackCamera
    case other

    public var description: String {
        switch self {
        case .audioBluetooth:
            return "audioBluetooth"
        case .audioWiredHeadset:
            return "audioWiredHeadset"
        case .audioBuiltInSpeaker:
            return "audioBuiltInSpeaker"
        case .audioHandset:
            return "audioHandset"
        case .videoFrontCamera:
            return "videoFrontCamera"
        case .videoBackCamera:
            return "videoBackCamera"
        case .other:
            return "other"
        }
    }
}
