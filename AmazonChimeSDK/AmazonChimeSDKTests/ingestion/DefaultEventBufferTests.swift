//
//  DefaultEventBufferTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Cuckoo
import XCTest

class DefaultEventBufferTests: XCTestCase {
    private var eventSqliteBuffer: DefaultEventBuffer!
    private var eventDao: MockEventDao!
    private var dirtyEventDao: MockDirtyEventDao!
    private var converter: MockIngestionEventConverter!
    private var ingestionConfiguration: IngestionConfiguration!
    private var eventSender: MockEventSender!
    private var logger: MockLogger!

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
        converter = MockIngestionEventConverter().withEnabledDefaultImplementation(IngestionEventConverterStub())
        eventDao = MockEventDao().withEnabledDefaultImplementation(EventDaoStub())
        dirtyEventDao = MockDirtyEventDao().withEnabledDefaultImplementation(DirtyEventDaoStub())
        eventSender = MockEventSender().withEnabledDefaultImplementation(EventSenderStub())
        logger = MockLogger().withEnabledDefaultImplementation(LoggerStub())
        stub(converter) { stub in
            when(stub.toIngestionRecord(meetingEvents: any(), ingestionConfiguration: any())).thenReturn(ingestionRecord)
            when(stub.toIngestionRecord(dirtyMeetingEvents: any(), ingestionConfiguration: any())).thenReturn(ingestionRecord)
            when(stub.toIngestionMeetingEvent(event: any(), ingestionConfiguration: any())).thenReturn(IngestionMeetingEvent(name: "dsfdsf", eventAttributes: [:]))
        }
        stub(dirtyEventDao) { stub in
            when(stub.queryDirtyMeetingEventItems(size: any())).thenReturn([DirtyMeetingEventItem(id: "aa", data: ingestionEvent, ttl: 11123)])
        }
        eventSqliteBuffer = DefaultEventBuffer(ingestionConfiguration: ingestionConfiguration,
                                              eventDao: eventDao,
                                              dirtyEventDao: dirtyEventDao,
                                              converter: converter,
                                              eventSender: eventSender,
                                              logger: logger)
    }

    func testAddShouldInvokeInsertMeetingEvent() {
        stub(eventDao) { stub in
            when(stub.insertMeetingEvent(event: any())).thenReturn(true)
        }

        eventSqliteBuffer.add(item: meetingEvent)

        verify(eventDao, times(1)).insertMeetingEvent(event: any())
    }

    func testProcessShouldInvokeInsertMeetingEvent() {
        stub(eventDao) { stub in
            when(stub.queryMeetingEventItems(size: any())).thenReturn([meetingEventItem])
        }
        stub(eventSender) { stub in
            when(stub.sendEvents(ingestionRecord: any(), completionHandler: any())).thenDoNothing()
        }

        eventSqliteBuffer.process()

        verify(eventDao, times(1)).queryMeetingEventItems(size: any())
        verify(eventSender, times(2)).sendEvents(ingestionRecord: any(), completionHandler: any())
        verify(converter, times(1)).toIngestionRecord(meetingEvents: any(), ingestionConfiguration: any())
    }
}
