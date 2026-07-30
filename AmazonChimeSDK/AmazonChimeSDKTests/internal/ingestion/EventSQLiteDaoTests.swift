//
//  EventSQLiteDaoTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class EventSQLiteDaoTests: XCTestCase {
    private var eventDao: EventSQLiteDao!
    private let tableName = "Events"
    private var sqliteManagerMock: DatabaseManagerSpy!
    private let mockMap = [
        "id": "6b1d60db-bfa3-41fd-8448-7737f961cf3d",
        "data": "{\"name\":\"meetingEnded\",\"eventAttributes\":{\"meetingStatus\":\"ok\"}}"
    ]
    private let uuid = UUID(uuidString: "6b1d60db-bfa3-41fd-8448-7737f961cf3d")?.uuidString
    private let mockMeetingEventItem = MeetingEventItem(id: UUID(uuidString: "6b1d60db-bfa3-41fd-8448-7737f961cf3d")!.uuidString,
                                                        data: IngestionMeetingEvent(name: String(describing: EventName.meetingEnded),
                                                                                    eventAttributes: [:]))
    override func setUp() {
        sqliteManagerMock = DatabaseManagerSpy()
        let loggerMock = LoggerSpy()
        sqliteManagerMock.queryReturn = [mockMap]
        sqliteManagerMock.insertReturn = true
        sqliteManagerMock.insertMultiplesReturn = true
        sqliteManagerMock.deleteReturn = true
        eventDao = EventSQLiteDao(sqliteManager: sqliteManagerMock, logger: loggerMock)
    }

    func testQueryShouldCallDatabaseManagerQuery() {
        eventDao.queryMeetingEventItems(size: 10)
        verify(sqliteManagerMock.queryCalls) { $0.tableName == self.tableName && $0.size == 10 }
    }

    func testQueryShouldReturnMeetingEventItem() {
        let items = eventDao.queryMeetingEventItems(size: 10)

        XCTAssertNotNil(items)
        XCTAssertGreaterThan(items.count, 0)
        XCTAssertEqual(String(describing: EventName.meetingEnded), items[0].data.name)
    }

    func testInsertShouldCallDatabaseManagerWrite() {
        eventDao.insertMeetingEvent(event: mockMeetingEventItem)
        verify(sqliteManagerMock.insertCalls) { $0.tableName == self.tableName }
    }

    func testDeleteShouldCallDatabaseManagerWrite() {
        eventDao.deleteMeetingEventsByIds(ids: [uuid!])
        verify(sqliteManagerMock.deleteCalls) { $0.tableName == self.tableName }
    }

    func testConstructorShouldCallDatabaseManagerExecute() {
        eventDao.deleteMeetingEventsByIds(ids: [uuid!])
        verify(sqliteManagerMock.deleteCalls) { $0.tableName == self.tableName }
    }
}
