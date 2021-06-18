//
//  IngestionMetadata.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers public class IngestionMetadata: NSObject, Codable {
    public let osName: String?
    public let osVersion: String?
    public let sdkVersion: String?
    public let mediaSdkVersion: String?
    public let sdkName: String?
    public let deviceName: String?
    public let deviceManufacturer: String?
    public let deviceModel: String?
    public let meetingId: String?
    public let attendeeId: String?

    init(osName: String? = nil,
         osVersion: String? = nil,
         sdkVersion: String? = nil,
         sdkName: String? = nil,
         mediaSdkVersion: String? = nil,
         deviceName: String? = nil,
         deviceManufacturer: String? = nil,
         deviceModel: String? = nil,
         meetingId: String? = nil,
         attendeeId: String? = nil)
    {
        self.osName = osName
        self.osVersion = osVersion
        self.sdkName = sdkName
        self.sdkVersion = sdkVersion
        self.mediaSdkVersion = mediaSdkVersion
        self.deviceName = deviceName
        self.deviceManufacturer = deviceManufacturer
        self.deviceModel = deviceModel
        self.meetingId = meetingId
        self.attendeeId = attendeeId
    }
}
