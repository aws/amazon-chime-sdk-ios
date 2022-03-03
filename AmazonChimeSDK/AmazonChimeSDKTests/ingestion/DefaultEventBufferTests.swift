//
//  DefaultEventBufferTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Mockingbird
import XCTest

class DefaultEventBufferTests: XCTestCase {
    private var eventSqliteBuffer: DefaultEventBuffer!
    private var eventDao: EventDaoMock!
    private var dirtyEventDao: DirtyEventDaoMock!
    private var converter: IngestionEventConverterMock!
    private var ingestionConfiguration: IngestionConfiguration!
    private var eventSender: EventSenderMock!
    private var logger: LoggerMock!

    private let meetingEvent = SDKEvent(eventName: EventName.meetingEnded, eventAttributes: [EventAttributeName.poorConnectionCount: 0])

    private let ingestionEvent = IngestionMeetingEvent(name: String(describing: EventName.meetingEnded),
                                                      eventAttributes: IngestionEventAttributes())
    private let meetingEventItem = MeetingEventItem(id: "sdfdf",
                                                    data: IngestionMeetingEvent(name: String(describing: EventName.meetingEnded),
                                                                                             eventAttributes: IngestionEventAttributes()))
    private let ingestionRecord = IngestionRecord(metadata: IngestionMetadata(), events: [IngestionEvent(type: "Meet",
                                                                                                         metadata: IngestionMetadata(),
                                                                                                         payloads: [IngestionPayload(name: "aeeee", ts: 1232132)])])
    override func setUp() {
        ingestionConfiguration = IngestionConfigurationBuilder().build(disabled: false,
                                                                       ingestionUrl: "a",
                                                                       clientConiguration: MeetingEventClientConfiguration(eventClientJoinToken: "",
                                                                                                                           meetingId: "",
                                                                                                                           attendeeId: ""))
        converter = mock(IngestionEventConverter.self).initialize()
        eventDao = mock(EventDao.self)
        dirtyEventDao = mock(DirtyEventDao.self)
        eventSender = mock(EventSender.self)
        logger = mock(Logger.self)
        given(converter.toIngestionRecord(meetingEvents: any(), ingestionConfiguration: any())).willReturn(ingestionRecord)
        given(converter.toIngestionRecord(dirtyMeetingEvents: any(), ingestionConfiguration: any())).willReturn(ingestionRecord)
        given(dirtyEventDao.queryDirtyMeetingEventItems(size: any())).willReturn([DirtyMeetingEventItem(id: "aa", data: ingestionEvent, ttl: 11123)])

        given(converter.toIngestionMeetingEvent(event: any(), ingestionConfiguration: any())).willReturn(IngestionMeetingEvent(name: "dsfdsf", eventAttributes: IngestionEventAttributes()))
        eventSqliteBuffer = DefaultEventBuffer(ingestionConfiguration: ingestionConfiguration,
                                              eventDao: eventDao,
                                              dirtyEventDao: dirtyEventDao,
                                              converter: converter,
                                              eventSender: eventSender,
                                              logger: logger)
    }

    func testAddShouldInvokeInsertMeetingEvent() {
        given(eventDao.insertMeetingEvent(event: any())).willReturn(true)

        eventSqliteBuffer.add(item: meetingEvent)

        verify(eventDao.insertMeetingEvent(event: any())).wasCalled(1)
    }

    func testProcessShouldInvokeInsertMeetingEvent() {
        given(eventDao.queryMeetingEventItems(size: any())).willReturn([meetingEventItem])
        given(eventSender.sendEvents(ingestionRecord: any(), completionHandler: any())).willReturn()

        eventSqliteBuffer.process()

        verify(eventDao.queryMeetingEventItems(size: any())).wasCalled(1)
        verify(eventSender.sendEvents(ingestionRecord: any(), completionHandler: any())).wasCalled(2)
        verify(converter.toIngestionRecord(meetingEvents: any(), ingestionConfiguration: any())).wasCalled(1)
    }
}
