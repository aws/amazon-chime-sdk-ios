//
//  SignalUpdate.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
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
