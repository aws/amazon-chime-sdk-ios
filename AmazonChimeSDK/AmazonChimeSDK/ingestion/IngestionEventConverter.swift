//
//  IngestionEventConverter.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `IngestionEventConverter` converts data from payload into `MeetingEventItem`/`DirtyEventItem`or vice versa.
@objcMembers public class IngestionEventConverter: NSObject {
    private let nameKey = "name"
    private let timestampKey = "ts"
    private let idKey = "id"
    private let ttlKey = "ttl"

    public override init() {
        super.init()
    }

    func toIngestionMeetingEvent(event: SDKEvent, ingestionConfiguration: IngestionConfiguration) -> IngestionMeetingEvent {
        let eventAttributes = event.eventAttributes
        let meetingConfig = ingestionConfiguration.clientConfiguration as? MeetingEventClientConfiguration

        var meetingStatus: String?
        if let status = eventAttributes[EventAttributeName.meetingStatus] as? MeetingSessionStatusCode {
            meetingStatus = String(describing: status)
        }

        var videoErrorStr: String?
        if let videoError = eventAttributes[EventAttributeName.videoInputError] as? CaptureSourceError {
            videoErrorStr = String(describing: videoError)
        }

        // Some meta data like meetingId is needed
        // Since these meta data changes from meeting to meeting
        return IngestionMeetingEvent(name: String(describing: event.name),
                                     eventAttributes: IngestionEventAttributes(timestampMs: eventAttributes[EventAttributeName.timestampMs] as? Int64,
                                                                               maxVideoTileCount: eventAttributes[EventAttributeName.maxVideoTileCount] as? Int,
                                                                               meetingStartDurationMs: eventAttributes[EventAttributeName.meetingStartDurationMs] as? Int64,
                                                                               meetingDurationMs: eventAttributes[EventAttributeName.meetingDurationMs] as? Int64,
                                                                               meetingErrorMessage:
                                                                               eventAttributes[EventAttributeName.meetingErrorMessage] as? String,
                                                                               meetingStatus: meetingStatus,
                                                                               poorConnectionCount: eventAttributes[EventAttributeName.poorConnectionCount] as? Int,
                                                                               retryCount: eventAttributes[EventAttributeName.retryCount] as? Int,
                                                                               videoInputError: videoErrorStr,
                                                                               meetingId: meetingConfig?.meetingId,
                                                                               attendeeId: meetingConfig?.attendeeId))
    }

    func toIngestionRecord(dirtyMeetingEvents: [DirtyMeetingEventItem], ingestionConfiguration: IngestionConfiguration) -> IngestionRecord {
        if dirtyMeetingEvents.isEmpty {
            return IngestionRecord(metadata: IngestionMetadata(), events: [])
        }

        let dirtyMeetingEventsGrouped = Dictionary(grouping: dirtyMeetingEvents, by: { $0.data.eventAttributes.meetingId })

        let ingestionEvents = dirtyMeetingEventsGrouped.compactMap { (group) -> IngestionEvent? in
            if let dirtyMeetingEventItem = group.value.first {
                return IngestionEvent(type: String(describing: EventClientType.meet),
                               metadata: toIngestionMetadata(ingestionMeetingEvent: dirtyMeetingEventItem.data),
                               payloads: group.value.map { dirtyMeetingEvent in
                                   toIngestionPayload(dirtyMeetingEvent: dirtyMeetingEvent)
                               })
            }
            return nil
        }

        let rootMeta = toIngestionMetadata(attributes: EventAttributeUtils.getCommonAttributes(ingestionConfiguration: ingestionConfiguration))

        return IngestionRecord(metadata: rootMeta,
                               events: ingestionEvents)
    }

    func toIngestionRecord(meetingEvents: [MeetingEventItem], ingestionConfiguration: IngestionConfiguration) -> IngestionRecord {
        if meetingEvents.isEmpty {
            return IngestionRecord(metadata: IngestionMetadata(), events: [])
        }
        let meetingEventsByMeetingId = Dictionary(grouping: meetingEvents, by: { $0.data.eventAttributes.meetingId })

        let type = String(describing: EventClientType.meet)

        // When sending a batch, server accepts the data as
        // "events": [
        //   {
        //      "metadata": { "meetingId": "meetingId2" } // This overrides record level metadata
        //      "type": "Meet",
        //      "v": 1,
        //      "payloads": []
        //   },
        //   {
        //      "metadata": { "meetingId": "meetingId1" } // This overrides record level metadata
        //      "type": "Meet",
        //      "v": 1,
        //      "payloads": []
        //   },
        // ]
        // This is to group events so that it contains different metadata to override
        let ingestionEvents = meetingEventsByMeetingId.compactMap { (group) -> IngestionEvent? in
            if let meetingEventItem = group.value.first {
                return IngestionEvent(type: type,
                                      metadata: toIngestionMetadata(ingestionMeetingEvent: meetingEventItem.data),
                                      payloads: group.value.map { meetingEvent in
                                          toIngestionPayload(meetingEvent: meetingEvent)
                                      })
            }
            return nil
        }

        let rootMeta = toIngestionMetadata(attributes: EventAttributeUtils.getCommonAttributes(ingestionConfiguration: ingestionConfiguration))

        return IngestionRecord(metadata: rootMeta,
                               events: ingestionEvents)
    }

    private func toIngestionPayload(meetingEvent: MeetingEventItem) -> IngestionPayload {
        let attributes = meetingEvent.data.eventAttributes

        return IngestionPayload(name: meetingEvent.data.name,
                                ts: attributes.timestampMs ?? 0,
                                id: meetingEvent.id,
                                maxVideoTileCount: attributes.maxVideoTileCount,
                                meetingStartDurationMs: attributes.meetingStartDurationMs,
                                meetingDurationMs: attributes.meetingDurationMs,
                                meetingErrorMessage: attributes.meetingErrorMessage,
                                meetingStatus: attributes.meetingStatus,
                                poorConnectionCount: attributes.poorConnectionCount,
                                retryCount: attributes.retryCount,
                                videoInputErrorMessage: String(describing: attributes.videoInputError))
    }

    private func toIngestionPayload(dirtyMeetingEvent: DirtyMeetingEventItem) -> IngestionPayload {
        let attributes = dirtyMeetingEvent.data.eventAttributes

        return IngestionPayload(name: dirtyMeetingEvent.data.name,
                                ts: attributes.timestampMs ?? 0,
                                id: dirtyMeetingEvent.id,
                                maxVideoTileCount: attributes.maxVideoTileCount,
                                meetingStartDurationMs: attributes.meetingStartDurationMs,
                                meetingDurationMs: attributes.meetingDurationMs,
                                meetingErrorMessage: attributes.meetingErrorMessage,
                                meetingStatus: attributes.meetingStatus,
                                poorConnectionCount: attributes.poorConnectionCount,
                                retryCount: attributes.retryCount,
                                videoInputErrorMessage: String(describing: attributes.videoInputError),
                                ttl: dirtyMeetingEvent.ttl)
    }

    private func toIngestionMetadata(attributes: [AnyHashable: Any]) -> IngestionMetadata {
        return IngestionMetadata(osName: attributes[EventAttributeName.osName] as? String,
                                 osVersion: attributes[EventAttributeName.osName] as? String,
                                 sdkVersion: attributes[EventAttributeName.sdkVersion] as? String,
                                 sdkName: attributes[EventAttributeName.sdkName] as? String,
                                 mediaSdkVersion: attributes[EventAttributeName.mediaSdkVersion] as? String,
                                 deviceName: attributes[EventAttributeName.deviceName] as? String,
                                 deviceManufacturer: attributes[EventAttributeName.deviceManufacturer] as? String,
                                 deviceModel: attributes[EventAttributeName.deviceModel] as? String,
                                 meetingId: attributes[EventAttributeName.meetingId] as? String,
                                 attendeeId: attributes[EventAttributeName.attendeeId] as? String)
    }

    private func toIngestionMetadata(ingestionMeetingEvent: IngestionMeetingEvent) -> IngestionMetadata {
        return IngestionMetadata(meetingId: ingestionMeetingEvent.eventAttributes.meetingId,
                                 attendeeId: ingestionMeetingEvent.eventAttributes.attendeeId)
    }
}
