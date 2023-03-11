//
//  EventAttributesUtils.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

class EventAttributeUtils {
    static var commonEventAttributes = [
        EventAttributeName.deviceName.description: DeviceUtils.deviceName,
        EventAttributeName.deviceManufacturer.description: DeviceUtils.manufacturer,
        EventAttributeName.deviceModel.description: DeviceUtils.deviceModel,
        EventAttributeName.osName.description: DeviceUtils.osName,
        EventAttributeName.osVersion.description: DeviceUtils.osVersion,
        EventAttributeName.sdkName.description: DeviceUtils.sdkName,
        EventAttributeName.sdkVersion.description: DeviceUtils.sdkVersion,
        EventAttributeName.mediaSdkVersion.description: DeviceUtils.mediaSDKVersion
    ] as [String: Any]

    class func getCommonAttributes(ingestionConfiguration: IngestionConfiguration) -> [String: Any] {
        var localCommonEventAttributes = commonEventAttributes

        ingestionConfiguration.clientConfiguration.metadataAttributes.forEach { (key: String, value: Any) in
            localCommonEventAttributes[key] = value
        }

        return localCommonEventAttributes
    }

    class func getCommonAttributes(meetingSessionConfig: MeetingSessionConfiguration) -> [String: Any] {
        var localCommonEventAttributes = [
            EventAttributeName.meetingId.description: meetingSessionConfig.meetingId,
            EventAttributeName.attendeeId.description: meetingSessionConfig.credentials.attendeeId,
            EventAttributeName.externalUserId.description: meetingSessionConfig.credentials.externalUserId
        ] as [String: Any]

        localCommonEventAttributes = localCommonEventAttributes.merging(commonEventAttributes, uniquingKeysWith: { (_, newItem) -> Any in
            newItem
        })

        if let externalMeetingId = meetingSessionConfig.externalMeetingId {
            localCommonEventAttributes[EventAttributeName.externalMeetingId.description] = externalMeetingId
        }

        return localCommonEventAttributes
    }
}
