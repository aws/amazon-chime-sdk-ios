//
//  EventSQLiteDaoTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Mockingbird
import XCTest

class EventSQLiteDaoTests: XCTestCase {
    private var eventDao: EventSQLiteDao!
    private let tableName = "Events"
    private var sqliteManagerMock: DatabaseManagerMock!
    private let mockMap = [
        "id": "6b1d60db-bfa3-41fd-8448-7737f961cf3d",
        "data": "{\"name\":\"meetingEnded\",\"eventAttributes\":{\"meetingStatus\":\"ok\"}}"
    ]
    private let uuid = UUID(uuidString: "6b1d60db-bfa3-41fd-8448-7737f961cf3d")?.uuidString
    private let mockMeetingEventItem = MeetingEventItem(id: UUID(uuidString: "6b1d60db-bfa3-41fd-8448-7737f961cf3d")!.uuidString,
                                                        data: IngestionMeetingEvent(name: String(describing: EventName.meetingEnded),
                                                                                    eventAttributes: [:]))
    override func setUp() {
        sqliteManagerMock = mock(DatabaseManager.self)
        let loggerMock = mock(Logger.self)
        given(sqliteManagerMock.query(tableName: any(), size: any())).willReturn([mockMap])
        given(sqliteManagerMock.insert(tableName: any(), contentValue: any())).willReturn(true)
        given(sqliteManagerMock.insertMultiples(tableName: any(), contentValues: any())).willReturn(true)
        given(sqliteManagerMock.delete(tableName: any(), ids: any())).willReturn(true)
        eventDao = EventSQLiteDao(sqliteManager: sqliteManagerMock, logger: loggerMock)
    }

    func testQueryShouldCallDatabaseManagerQuery() {
        eventDao.queryMeetingEventItems(size: 10)
        verify(sqliteManagerMock.query(tableName: self.tableName, size: 10)).wasCalled(1)
    }

    func testQueryShouldReturnMeetingEventItem() {
        let items = eventDao.queryMeetingEventItems(size: 10)

        XCTAssertNotNil(items)
        XCTAssertGreaterThan(items.count, 0)
        XCTAssertEqual(String(describing: EventName.meetingEnded), items[0].data.name)
    }

    func testInsertShouldCallDatabaseManagerWrite() {
        eventDao.insertMeetingEvent(event: mockMeetingEventItem)
        verify(sqliteManagerMock.insert(tableName: self.tableName, contentValue: any())).wasCalled(1)
    }

    func testDeleteShouldCallDatabaseManagerWrite() {
        eventDao.deleteMeetingEventsByIds(ids: [uuid!])
        verify(sqliteManagerMock.delete(tableName: self.tableName, ids: any())).wasCalled(1)
    }

    func testConstructorShouldCallDatabaseManagerExecute() {
        eventDao.deleteMeetingEventsByIds(ids: [uuid!])
        verify(sqliteManagerMock.delete(tableName: self.tableName, ids: any())).wasCalled(1)
    }
}
