//
//  IngestionEventConverter.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

private typealias EAName = EventAttributeName

/// `IngestionEventConverter` converts data from payload into `MeetingEventItem`/`DirtyEventItem`or vice versa.
@objcMembers public class IngestionEventConverter: NSObject {

    public override init() {
        super.init()
    }

    func toIngestionMeetingEvent(event: SDKEvent,
                                 ingestionConfiguration: IngestionConfiguration) -> IngestionMeetingEvent {
        let eventAttributes = event.eventAttributes
        let clientConfig = ingestionConfiguration.clientConfiguration

        var meetingStatus: String?
        if let status = eventAttributes[EventAttributeName.meetingStatus] as? MeetingSessionStatusCode {
            meetingStatus = String(describing: status)
        }

        var videoErrorStr: String?
        if let videoError = eventAttributes[EventAttributeName.videoInputError] as? Error {
            videoErrorStr = String(describing: videoError)
        }
        
        var audioErrorStr: String?
        if let audioError = eventAttributes[EventAttributeName.audioInputError] as? Error {
            audioErrorStr = String(describing: audioError)
        }
        
        var signalingDroppedErrorStr: String?
        if let signalingDroppedError = eventAttributes[EventAttributeName.signalingDroppedError] as? Error {
            signalingDroppedErrorStr = String(describing: signalingDroppedError)
        }
        
        var appStateStr: String?
        if let appState = eventAttributes[EventAttributeName.appState] as? AppState {
            appStateStr = String(describing: appState)
        }

        var attributes = [String:AnyCodable]()
        attributes[EAName.timestampMs.description] = AnyCodable(eventAttributes[EAName.timestampMs])
        attributes[EAName.maxVideoTileCount.description] = AnyCodable(eventAttributes[EAName.maxVideoTileCount])
        attributes[EAName.meetingStartDurationMs.description] = AnyCodable(
            eventAttributes[EAName.meetingStartDurationMs]
        )
        attributes[EAName.meetingReconnectDurationMs.description] = AnyCodable(
            eventAttributes[EAName.meetingReconnectDurationMs]
        )
        attributes[EAName.meetingDurationMs.description] = AnyCodable(eventAttributes[EAName.meetingDurationMs])
        attributes[EAName.meetingErrorMessage.description] = AnyCodable(eventAttributes[EAName.meetingErrorMessage])
        attributes[EAName.meetingStatus.description] = AnyCodable(meetingStatus)
        attributes[EAName.poorConnectionCount.description] = AnyCodable(eventAttributes[EAName.poorConnectionCount])
        attributes[EAName.retryCount.description] = AnyCodable(eventAttributes[EAName.retryCount])
        attributes[EAName.videoInputError.description] = AnyCodable(videoErrorStr)
        attributes[EAName.audioInputError.description] = AnyCodable(audioErrorStr)
        attributes[EAName.signalingDroppedError.description] = AnyCodable(signalingDroppedErrorStr)
        attributes[EAName.appState.description] = AnyCodable(appStateStr)
        if let batteryLevel = eventAttributes[EventAttributeName.batteryLevel] as? NSNumber {
            attributes[EAName.batteryLevel.description] = AnyCodable(batteryLevel.floatValue)
        }
        
        if let batteryState = eventAttributes[EventAttributeName.batteryState] as? BatteryState {
            let batteryStateStr = String(describing: batteryState)
            attributes[EAName.batteryState.description] = AnyCodable(batteryStateStr)
        }
        
        if let contentShareError = eventAttributes[EAName.contentShareError] as? VideoClientFailedError {
            let contentShareErrorStr = String(describing: contentShareError)
            attributes[EAName.contentShareError.description] = AnyCodable(contentShareErrorStr)
        }
        
        if let voiceFocusError = eventAttributes[EAName.voiceFocusError] as? VoiceFocusError {
            let voiceFocusErrorStr = String(describing: voiceFocusError)
            attributes[EAName.voiceFocusError.description] = AnyCodable(voiceFocusErrorStr)
        }
        
        if let audioDeviceTypeStr = eventAttributes[EAName.audioDeviceType] as? String {
            attributes[EAName.audioDeviceType.description] = AnyCodable(audioDeviceTypeStr)
        }
        
        if let videoDeviceTypeStr = eventAttributes[EAName.videoDeviceType] as? String {
            attributes[EAName.videoDeviceType.description] = AnyCodable(videoDeviceTypeStr)
        }
        
        if let lowPowerModeEnabled = eventAttributes[EAName.lowPowerModeEnabled] as? Bool {
            attributes[EAName.lowPowerModeEnabled.description] = AnyCodable(lowPowerModeEnabled)
        }
        
        if let videoInterruptionReason = eventAttributes[EAName.videoInterruptionReason] as? VideoInterruptionReason {
            let reasonStr = String(describing: videoInterruptionReason)
            attributes[EAName.videoInterruptionReason.description] = AnyCodable(reasonStr)
        }
        
        attributes[EAName.iceGatheringDurationMs.description] = AnyCodable(eventAttributes[EAName.iceGatheringDurationMs])
        attributes[EAName.signalingOpenDurationMs.description] = AnyCodable(eventAttributes[EAName.signalingOpenDurationMs])
        if let networkConnectionType = eventAttributes[EAName.networkConnectionType] as? NetworkConnectionType {
            let typeStr = String(describing: networkConnectionType)
            attributes[EAName.networkConnectionType.description] = AnyCodable(typeStr)
        }
        
        clientConfig.metadataAttributes.forEach({ (key: String, value: Any) in
            attributes[key] = AnyCodable(value)
        })
        
        // Some meta data like meetingId is needed
        // Since these meta data changes from meeting to meeting
        return IngestionMeetingEvent(name: String(describing: event.name),
                                     eventAttributes: attributes)
    }

    func toIngestionRecord(dirtyMeetingEvents: [DirtyMeetingEventItem], ingestionConfiguration: IngestionConfiguration) -> IngestionRecord {
        if dirtyMeetingEvents.isEmpty {
            return IngestionRecord(metadata: [:], events: [])
        }

        // TODO: Group by meeting ID won't work since attendees can rejoin with different attendeeIDs
        let dirtyMeetingEventsGrouped = Dictionary(grouping: dirtyMeetingEvents, by: { $0.data.getMeetingId() })

        let eventType = ingestionConfiguration.clientConfiguration.tag
        
        let ingestionEvents = dirtyMeetingEventsGrouped.compactMap { (group) -> IngestionEvent? in
            if let sampleMeetingEventItem = group.value.first {
                // TODO: Using first event as sample for retrieveing metadata won't always work, since attendees can rejoin with different attendeeIDs
                let metadata = toIngestionMetadata(ingestionMeetingEvent: sampleMeetingEventItem.data,
                                                   clientConfig: ingestionConfiguration.clientConfiguration)
                let payloads = group.value.map {
                    toIngestionPayload(meetingEventItemId: $0.id,
                                       meetingEvent: $0.data,
                                       dirtyMeetingEventTtl: $0.ttl)
                }
                return IngestionEvent(type: eventType,
                                      metadata: metadata,
                                      payloads: payloads)
            }
            return nil
        }

        let rootMeta = toIngestionMetadata(attributes: EventAttributeUtils.getCommonAttributes(ingestionConfiguration: ingestionConfiguration))

        return IngestionRecord(metadata: rootMeta,
                               events: ingestionEvents)
    }

    func toIngestionRecord(meetingEvents: [MeetingEventItem], ingestionConfiguration: IngestionConfiguration) -> IngestionRecord {
        if meetingEvents.isEmpty {
            return IngestionRecord(metadata: [:], events: [])
        }
        // TODO: Group by meeting ID won't work since attendees can rejoin with different attendeeID
        let meetingEventsByMeetingId = Dictionary(grouping: meetingEvents,
                                                  by: { $0.data.getMeetingId() })

        let type = ingestionConfiguration.clientConfiguration.tag

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
            if let sampleMeetingEventItem = group.value.first {
                // TODO: Using first event as sample for retrieveing metadata won't always work, since attendees can rejoin with different attendeeIDs
                let metadata = toIngestionMetadata(ingestionMeetingEvent: sampleMeetingEventItem.data,
                                                   clientConfig: ingestionConfiguration.clientConfiguration)
                let payloads = group.value.map {
                    toIngestionPayload(meetingEventItemId: $0.id,
                                       meetingEvent: $0.data,
                                       dirtyMeetingEventTtl: nil)
                }
                return IngestionEvent(type: type,
                                      metadata: metadata,
                                      payloads: payloads)
            }
            return nil
        }

        let rootMeta = toIngestionMetadata(attributes: EventAttributeUtils.getCommonAttributes(ingestionConfiguration: ingestionConfiguration))

        return IngestionRecord(metadata: rootMeta,
                               events: ingestionEvents)
    }

    private func toIngestionPayload(meetingEventItemId: String,
                                    meetingEvent: IngestionMeetingEvent,
                                    dirtyMeetingEventTtl: Int64?) -> IngestionPayload {
        return IngestionPayload(name: meetingEvent.name,
                                ts: meetingEvent.getTimestampMs() ?? 0,
                                id: meetingEventItemId,
                                maxVideoTileCount: meetingEvent.getMaxVideoTileCount(),
                                meetingStartDurationMs: meetingEvent.getMeetingStartDurationMs(),
                                meetingReconnectDurationMs: meetingEvent.getMeetingReconnectDurationMs(),
                                meetingDurationMs: meetingEvent.getMeetingDurationMs(),
                                meetingErrorMessage: meetingEvent.getMeetingErrorMessage(),
                                meetingStatus: meetingEvent.getMeetingStatus(),
                                poorConnectionCount: meetingEvent.getPoorConnectionCount(),
                                retryCount: meetingEvent.getRetryCount(),
                                videoInputErrorMessage: meetingEvent.getVideoInputErrorMessage(),
                                audioInputErrorMessage: meetingEvent.getAudioInputErrorMessage(),
                                signalingDroppedErrorMessage: meetingEvent.getSignalingDroppedErrorMessage(),
                                contentShareErrorMessage: meetingEvent.getContentShareErrorMessage(),
                                appState: meetingEvent.getAppState(),
                                batteryLevel: meetingEvent.getBatteryLevel(),
                                batteryState: meetingEvent.getBatteryState(),
                                voiceFocusErrorMessage: meetingEvent.getVoiceFocusErrorMessage(),
                                audioDeviceType: meetingEvent.getAudioDeviceType(),
                                videoDeviceType: meetingEvent.getVideoDeviceType(),
                                lowPowerModeEnabled: meetingEvent.isLowPowerModeEnabled(),
                                videoInterruptionReason: meetingEvent.getVideoInterruptionReason(),
                                iceGatheringDurationMs: meetingEvent.getIceGatheringDurationMs(),
                                signalingOpenDurationMs: meetingEvent.getSignalingOpenDurationMs(),
                                networkConnectionType: meetingEvent.getNetworkConnectionType(),
                                ttl: dirtyMeetingEventTtl)
    }

    private func toIngestionMetadata(attributes: [String: Any]) -> [String: AnyCodable?] {
        var result = [String: AnyCodable]()
        attributes.forEach { (key: String, value: Any) in
            result[key] = AnyCodable(value)
        }
        return result
    }

    private func toIngestionMetadata(ingestionMeetingEvent: IngestionMeetingEvent,
                                     clientConfig: EventClientConfiguration) -> [String: AnyCodable?] {
        var result = [String: AnyCodable]()
        clientConfig.metadataAttributes.keys.forEach { key in
            result[key] = ingestionMeetingEvent.eventAttributes[key] ?? nil
        }
        return result
    }
}
