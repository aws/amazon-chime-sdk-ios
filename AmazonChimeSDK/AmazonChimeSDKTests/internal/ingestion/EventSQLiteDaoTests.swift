//
//  EventSQLiteDaoTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Cuckoo
import XCTest

class EventSQLiteDaoTests: XCTestCase {
    private var eventDao: EventSQLiteDao!
    private let tableName = "Events"
    private var sqliteManagerMock: MockDatabaseManager!
    private let mockMap = [
        "id": "6b1d60db-bfa3-41fd-8448-7737f961cf3d",
        "data": "{\"name\":\"meetingEnded\",\"eventAttributes\":{\"meetingStatus\":\"ok\"}}"
    ]
    private let uuid = UUID(uuidString: "6b1d60db-bfa3-41fd-8448-7737f961cf3d")?.uuidString
    private let mockMeetingEventItem = MeetingEventItem(id: UUID(uuidString: "6b1d60db-bfa3-41fd-8448-7737f961cf3d")!.uuidString,
                                                        data: IngestionMeetingEvent(name: String(describing: EventName.meetingEnded),
                                                                                    eventAttributes: [:]))
    override func setUp() {
        sqliteManagerMock = MockDatabaseManager().withEnabledDefaultImplementation(DatabaseManagerStub())
        let loggerMock = MockLogger().withEnabledDefaultImplementation(LoggerStub())
        stub(sqliteManagerMock) { stub in
            when(stub.query(tableName: any(), size: any())).thenReturn([mockMap])
            when(stub.insert(tableName: any(), contentValue: any())).thenReturn(true)
            when(stub.insertMultiples(tableName: any(), contentValues: any())).thenReturn(true)
            when(stub.delete(tableName: any(), ids: any())).thenReturn(true)
        }
        eventDao = EventSQLiteDao(sqliteManager: sqliteManagerMock, logger: loggerMock)
    }

    func testQueryShouldCallDatabaseManagerQuery() {
        eventDao.queryMeetingEventItems(size: 10)
        verify(sqliteManagerMock, times(1)).query(tableName: self.tableName, size: 10)
    }

    func testQueryShouldReturnMeetingEventItem() {
        let items = eventDao.queryMeetingEventItems(size: 10)

        XCTAssertNotNil(items)
        XCTAssertGreaterThan(items.count, 0)
        XCTAssertEqual(String(describing: EventName.meetingEnded), items[0].data.name)
    }

    func testInsertShouldCallDatabaseManagerWrite() {
        eventDao.insertMeetingEvent(event: mockMeetingEventItem)
        verify(sqliteManagerMock, times(1)).insert(tableName: self.tableName, contentValue: any())
    }

    func testDeleteShouldCallDatabaseManagerWrite() {
        eventDao.deleteMeetingEventsByIds(ids: [uuid!])
        verify(sqliteManagerMock, times(1)).delete(tableName: self.tableName, ids: any())
    }

    func testConstructorShouldCallDatabaseManagerExecute() {
        eventDao.deleteMeetingEventsByIds(ids: [uuid!])
        verify(sqliteManagerMock, times(1)).delete(tableName: self.tableName, ids: any())
    }
}
