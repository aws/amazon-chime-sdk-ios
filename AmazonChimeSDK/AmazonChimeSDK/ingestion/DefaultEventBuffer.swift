//
//  DefaultEventBuffer.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers class DefaultEventBuffer: NSObject, EventBuffer {
    private let ingestionConfiguration: IngestionConfiguration
    private let eventDao: EventDao
    private let converter: IngestionEventConverter
    private let dirtyEventDao: DirtyEventDao
    private let eventSender: EventSender
    private let logger: Logger
    private let eventReporterQueue = DispatchQueue(label: "eventSQLiteQueue",
                                                   qos: .background,
                                                   attributes: .concurrent)
    private let twoDaysInMilliSeconds: Int64 = 172800000

    init(ingestionConfiguration: IngestionConfiguration,
         eventDao: EventDao,
         dirtyEventDao: DirtyEventDao,
         converter: IngestionEventConverter,
         eventSender: EventSender,
         logger: Logger)
    {
        self.ingestionConfiguration = ingestionConfiguration
        self.dirtyEventDao = dirtyEventDao
        self.eventDao = eventDao
        self.converter = converter
        self.eventSender = eventSender
        self.logger = logger
        super.init()
        self.processDirtyEvents()
    }

    func add(item: SDKEvent) {
        let uuid = UUID().uuidString

        let meetingItem = MeetingEventItem(id: uuid,
                                           data: converter.toIngestionMeetingEvent(event: item,
                                                                                   ingestionConfiguration: ingestionConfiguration))
        // If there is meeting failure, it is possible that people just close the app.
        // In order to not lose the data, we put it in the db even for immediate events
        eventDao.insertMeetingEvent(event: meetingItem)

        sendIfImmediateEvents(item: item, meetingItem: meetingItem)
    }

    func process() {
        processEvents(meetingEventItems: eventDao.queryMeetingEventItems(size: ingestionConfiguration.flushSize))
    }

    private func sendIfImmediateEvents(item: SDKEvent, meetingItem: MeetingEventItem) {
        let eventName = item.name
        let eventAttributes = item.eventAttributes
        if shouldImmediatelySend(eventName: eventName, eventAttributes: eventAttributes) {
            processEvents(meetingEventItems: [meetingItem])
        }
    }

    private func remove(ids: [String]) {
        if ids.isEmpty {
            return
        }
        eventDao.deleteMeetingEventsByIds(ids: ids)
    }

    private func toDirtyMeetingEventItems(items: [MeetingEventItem]) -> [DirtyMeetingEventItem] {
        let currentTime = DateUtils.getCurrentTimeStampMs()
        return items.map { (item) -> DirtyMeetingEventItem in
            DirtyMeetingEventItem(id: item.id, data: item.data, ttl: currentTime + twoDaysInMilliSeconds)
        }
    }

    func processEvents(meetingEventItems: [MeetingEventItem]) {
        eventReporterQueue.sync {
            let ingestionRecord = self.converter.toIngestionRecord(meetingEvents: meetingEventItems, ingestionConfiguration:ingestionConfiguration)
            if ingestionRecord.events.isEmpty {
                return
            }
            let idsToRemove = ingestionRecord.events.flatMap { (ingestionEvent: IngestionEvent) -> [String] in
                ingestionEvent.payloads.compactMap { (payload) -> String? in
                    payload.id
                }
            }
            self.eventSender.sendEvents(ingestionRecord: ingestionRecord) { isSuccess in
                if !isSuccess {
                    self.logger.info(msg: "Unable to send http request. Putting it in dirty events")
                    self.dirtyEventDao.insertDirtyMeetingEventItems(dirtyEvents: self.toDirtyMeetingEventItems(items: meetingEventItems))
                }
                self.remove(ids: idsToRemove)
            }
        }
    }

    private func shouldImmediatelySend(eventName: String, eventAttributes: [AnyHashable: Any]) -> Bool {
        if let meetingStatus = eventAttributes[EventAttributeName.meetingStatus] as? MeetingSessionStatusCode {
            return (eventName == String(describing: EventName.meetingFailed) &&
                (meetingStatus == .audioAuthenticationRejected ||
                    meetingStatus == .audioInternalServerError ||
                    meetingStatus == .audioServiceUnavailable ||
                    meetingStatus == .audioDisconnected)) || eventName == String(describing: EventName.meetingEnded)
        }
        return false
    }

    private func processDirtyEvents() {
        eventReporterQueue.sync {
            let dirtyEvents = dirtyEventDao.queryDirtyMeetingEventItems(size: ingestionConfiguration.flushSize)
            let ingestionRecord = converter.toIngestionRecord(dirtyMeetingEvents: dirtyEvents, ingestionConfiguration: ingestionConfiguration)
            if !ingestionRecord.events.isEmpty {
                // Keep sending it until dirtyevents are emtpy
                // if it still fails and ttl is less than current time
                // just delete them
                eventSender.sendEvents(ingestionRecord: ingestionRecord) { isSuccess in
                    if isSuccess {
                        let idsToRemove = ingestionRecord.events.flatMap { (ingestionEvent: IngestionEvent) -> [String] in
                            ingestionEvent.payloads.compactMap { (payload) -> String? in
                                payload.id
                            }
                        }
                        self.removeDirtyEvents(ids: idsToRemove)
                        self.processDirtyEvents()
                    } else {
                        let currentTime = DateUtils.getCurrentTimeStampMs()
                        let idsToRemove = ingestionRecord.events.flatMap { (ingestionEvent: IngestionEvent) -> [String] in
                            ingestionEvent.payloads.filter { (payload) -> Bool in
                                if let ttl = payload.ttl {
                                    return ttl < currentTime
                                }
                                return true
                            }.compactMap { (payload) -> String? in
                                payload.id
                            }
                        }
                        self.removeDirtyEvents(ids: idsToRemove)
                    }
                }
            }
        }
    }

    private func removeDirtyEvents(ids: [String]) {
        if ids.isEmpty {
            return
        }

        dirtyEventDao.deleteDirtyMeetingEventsByIds(ids: ids)
    }
}
