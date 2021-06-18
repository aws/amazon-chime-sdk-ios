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
        EventAttributeName.deviceName: DeviceUtils.deviceName,
        EventAttributeName.deviceManufacturer: DeviceUtils.manufacturer,
        EventAttributeName.deviceModel: DeviceUtils.deviceModel,
        EventAttributeName.osName: DeviceUtils.osName,
        EventAttributeName.osVersion: DeviceUtils.osVersion,
        EventAttributeName.sdkName: DeviceUtils.sdkName,
        EventAttributeName.sdkVersion: DeviceUtils.sdkVersion,
        EventAttributeName.mediaSdkVersion: DeviceUtils.mediaSDKVersion
    ] as [EventAttributeName: Any]

    class func getCommonAttributes() -> [AnyHashable: Any] {
        // Create a copy and return
        let localCommonEventAttributes = commonEventAttributes

        return localCommonEventAttributes
    }

    class func getCommonAttributes(ingestionConfiguration: IngestionConfiguration) -> [AnyHashable: Any] {
        var localCommonEventAttributes = commonEventAttributes

        if ingestionConfiguration.clientConfiguration.type == .meet, let meetingConfig = ingestionConfiguration.clientConfiguration as? MeetingEventClientConfiguration {
            localCommonEventAttributes = localCommonEventAttributes.merging([
                EventAttributeName.attendeeId: meetingConfig.attendeeId,
                EventAttributeName.meetingId: meetingConfig.meetingId
            ], uniquingKeysWith: { (_, newVal) -> Any in
                newVal
            })
        }

        return localCommonEventAttributes
    }

    class func getCommonAttributes(meetingSessionConfig: MeetingSessionConfiguration) -> [AnyHashable: Any] {
        var localCommonEventAttributes = [
            EventAttributeName.meetingId: meetingSessionConfig.meetingId,
            EventAttributeName.attendeeId: meetingSessionConfig.credentials.attendeeId,
            EventAttributeName.externalUserId: meetingSessionConfig.credentials.externalUserId
        ] as [EventAttributeName: Any]

        localCommonEventAttributes = localCommonEventAttributes.merging(commonEventAttributes, uniquingKeysWith: { (_, newItem) -> Any in
            newItem
        })

        if let externalMeetingId = meetingSessionConfig.externalMeetingId {
            localCommonEventAttributes[EventAttributeName.externalMeetingId] = externalMeetingId
        }

        return localCommonEventAttributes
    }
}
