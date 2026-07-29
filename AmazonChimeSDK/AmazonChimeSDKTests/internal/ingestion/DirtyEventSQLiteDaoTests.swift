//
//  DirtyEventSQLiteDaoTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Cuckoo
import XCTest

class DirtyEventSQLiteDaoTests: XCTestCase {
    private var dirtyEventDao: DirtyEventSQLiteDao!
    private var sqliteManagerMock: MockDatabaseManager!
    private let tableName = "DirtyEvents"
    private let mockMap = [
        "id": "6b1d60db-bfa3-41fd-8448-7737f961cf3d",
        "data": "{\"name\":\"meetingEnded\",\"eventAttributes\":{\"meetingStatus\":\"ok\"}}",
        "ttl": Int64(1000299292)
    ] as [String: Any]
    private let uuid = UUID(uuidString: "6b1d60db-bfa3-41fd-8448-7737f961cf3d")?.uuidString
    private let mockDirtyMeetingEventItem = DirtyMeetingEventItem(id: UUID(uuidString: "6b1d60db-bfa3-41fd-8448-7737f961cf3d")!.uuidString,
                                                                  data: IngestionMeetingEvent(name: String(describing: EventName.meetingEnded),
                                                                                              eventAttributes: [:]),
                                                                  ttl: Int64(1000299292))

    override func setUp() {
        sqliteManagerMock = MockDatabaseManager().withEnabledDefaultImplementation(DatabaseManagerStub())
        let loggerMock = MockLogger().withEnabledDefaultImplementation(LoggerStub())

        stub(sqliteManagerMock) { stub in
            when(stub.query(tableName: any(), size: any())).thenReturn([mockMap])
            when(stub.insert(tableName: any(), contentValue: any())).thenReturn(true)
            when(stub.insertMultiples(tableName: any(), contentValues: any())).thenReturn(true)
            when(stub.delete(tableName: any(), ids: any())).thenReturn(true)
        }

        dirtyEventDao = DirtyEventSQLiteDao(sqliteManager: sqliteManagerMock, logger: loggerMock)
    }

    func testQueryShouldCallDatabaseClientQuery() {
        dirtyEventDao.queryDirtyMeetingEventItems(size: 10)
        verify(sqliteManagerMock, times(1)).query(tableName: self.tableName, size: 10)
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
        verify(sqliteManagerMock, times(1)).insertMultiples(tableName: self.tableName, contentValues: any())
    }

    func testDeleteShouldCallDatabaseClientWrite() {
        dirtyEventDao.deleteDirtyMeetingEventsByIds(ids: [uuid!])
        verify(sqliteManagerMock, times(1)).delete(tableName: self.tableName, ids: any())
    }
}
