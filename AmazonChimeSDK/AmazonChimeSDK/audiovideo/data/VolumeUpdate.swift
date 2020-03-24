//
//  VolumeUpdate.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers public class VolumeUpdate: NSObject {
    public let attendeeInfo: AttendeeInfo
    public let volumeLevel: VolumeLevel

    init(attendeeInfo: AttendeeInfo, volumeLevel: VolumeLevel) {
        self.attendeeInfo = attendeeInfo
        self.volumeLevel = volumeLevel
    }
}
