//
//  SignalUpdate.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

@objcMembers public class SignalUpdate: NSObject {
    public let attendeeInfo: AttendeeInfo
    public let signalStrength: SignalStrength

    init(attendeeInfo: AttendeeInfo, signalStrength: SignalStrength) {
        self.attendeeInfo = attendeeInfo
        self.signalStrength = signalStrength
    }
}
