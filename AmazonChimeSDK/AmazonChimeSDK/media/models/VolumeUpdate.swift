//
//  VolumeUpdate.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
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
