//
//  DefaultEventBufferTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class DefaultEventBufferTests: XCTestCase {
    private var eventSqliteBuffer: DefaultEventBuffer!
    private var eventDao: EventDaoSpy!
    private var dirtyEventDao: DirtyEventDaoSpy!
    private var converter: IngestionEventConverterSpy!
    private var ingestionConfiguration: IngestionConfiguration!
    private var eventSender: EventSenderSpy!
    private var logger: LoggerSpy!

    private let meetingEvent = SDKEvent(eventName: EventName.meetingEnded, eventAttributes: [EventAttributeName.poorConnectionCount: 0])

    private let ingestionEvent = IngestionMeetingEvent(name: String(describing: EventName.meetingEnded),
                                                       eventAttributes: [:])
    private let meetingEventItem = MeetingEventItem(id: "sdfdf",
                                                    data: IngestionMeetingEvent(name: String(describing: EventName.meetingEnded),
                                                                                eventAttributes: [:]))
    private let ingestionRecord = IngestionRecord(metadata: [:],
                                                  events: [IngestionEvent(type: "Meet",
                                                                          metadata: [:],
                                                                          payloads: [IngestionPayload(name: "aeeee", ts: 1232132)])])
    override func setUp() {
        ingestionConfiguration = IngestionConfigurationBuilder().build(disabled: false,
                                                                       ingestionUrl: "a",
                                                                       clientConiguration: MeetingEventClientConfiguration(eventClientJoinToken: "",
                                                                                                                           meetingId: "",
                                                                                                                           attendeeId: ""))
        converter = IngestionEventConverterSpy()
        converter.toIngestionRecordReturn = ingestionRecord
        converter.toIngestionMeetingEventReturn = IngestionMeetingEvent(name: "dsfdsf", eventAttributes: [:])

        eventDao = EventDaoSpy()
        dirtyEventDao = DirtyEventDaoSpy()
        dirtyEventDao.queryDirtyMeetingEventItemsReturn = [DirtyMeetingEventItem(id: "aa", data: ingestionEvent, ttl: 11123)]
        eventSender = EventSenderSpy()
        logger = LoggerSpy()

        eventSqliteBuffer = DefaultEventBuffer(ingestionConfiguration: ingestionConfiguration,
                                              eventDao: eventDao,
                                              dirtyEventDao: dirtyEventDao,
                                              converter: converter,
                                              eventSender: eventSender,
                                              logger: logger)
    }

    func testAddShouldInvokeInsertMeetingEvent() {
        eventDao.insertMeetingEventReturn = true

        eventSqliteBuffer.add(item: meetingEvent)

        XCTAssertEqual(eventDao.insertMeetingEventCalls.count, 1)
    }

    func testProcessShouldInvokeInsertMeetingEvent() {
        eventDao.queryMeetingEventItemsReturn = [meetingEventItem]

        eventSqliteBuffer.process()

        XCTAssertEqual(eventDao.queryMeetingEventItemsCalls.count, 1)
        XCTAssertEqual(eventSender.sendEventsCalls.count, 2)
        XCTAssertEqual(converter.toIngestionRecordFromMeetingEventsCalls.count, 1)
    }
}
