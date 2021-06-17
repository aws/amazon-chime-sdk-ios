//
//  DirtyEventSQLiteDaoTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Mockingbird
import XCTest

class DirtyEventSQLiteDaoTests: XCTestCase {
    private var dirtyEventDao: DirtyEventSQLiteDao!
    private var sqliteManagerMock: DatabaseManagerMock!
    private let tableName = "DirtyEvents"
    private let mockMap = [
        "id": "6b1d60db-bfa3-41fd-8448-7737f961cf3d",
        "data": "{\"name\":\"meetingEnded\",\"eventAttributes\":{\"meetingStatus\":\"ok\"}}",
        "ttl": Int64(1000299292)
    ] as [String: Any]
    private let uuid = UUID(uuidString: "6b1d60db-bfa3-41fd-8448-7737f961cf3d")?.uuidString
    private let mockDirtyMeetingEventItem = DirtyMeetingEventItem(id: UUID(uuidString: "6b1d60db-bfa3-41fd-8448-7737f961cf3d")!.uuidString,
                                                                  data: IngestionMeetingEvent(name: String(describing: EventName.meetingEnded),
                                                                                              eventAttributes: IngestionEventAttributes()),
                                                                  ttl: Int64(1000299292))

    override func setUp() {
        sqliteManagerMock = mock(DatabaseManager.self)
        let loggerMock = mock(Logger.self)

        given(sqliteManagerMock.query(tableName: any(), size: any())).willReturn([mockMap])
        given(sqliteManagerMock.insert(tableName: any(), contentValue: any())).willReturn(true)
        given(sqliteManagerMock.insertMultiples(tableName: any(), contentValues: any())).willReturn(true)
        given(sqliteManagerMock.delete(tableName: any(), ids: any())).willReturn(true)

        dirtyEventDao = DirtyEventSQLiteDao(sqliteManager: sqliteManagerMock, logger: loggerMock)
    }

    func testQueryShouldCallDatabaseClientQuery() {
        dirtyEventDao.queryDirtyMeetingEventItems(size: 10)
        verify(sqliteManagerMock.query(tableName: self.tableName, size: 10)).wasCalled(1)
    }

    func testQueryShouldReturnMeetingEventItem() {
        let items = dirtyEventDao.queryDirtyMeetingEventItems(size: 10)

        XCTAssertNotNil(items)
        XCTAssertEqual(1, items.count)
        XCTAssertEqual(String(describing: EventName.meetingEnded), items[0].data.name)
        XCTAssertEqual(mockMap["ttl"] as? Int64, items[0].ttl)
    }

    func testInsertShouldCallDatabaseClientWrite() {
        dirtyEventDao.insertDirtyMeetingEventItems(dirtyEvents: [mockDirtyMeetingEventItem])
        verify(sqliteManagerMock.insertMultiples(tableName: self.tableName, contentValues: any())).wasCalled(1)
    }

    func testDeleteShouldCallDatabaseClientWrite() {
        dirtyEventDao.deleteDirtyMeetingEventsByIds(ids: [uuid!])
        verify(sqliteManagerMock.delete(tableName: self.tableName, ids: any())).wasCalled(1)
    }
}
