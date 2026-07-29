//
//  DirtyEventSQLiteDaoTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class DirtyEventSQLiteDaoTests: XCTestCase {
    private var dirtyEventDao: DirtyEventSQLiteDao!
    private var sqliteManagerMock: DatabaseManagerSpy!
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
        sqliteManagerMock = DatabaseManagerSpy()
        let loggerMock = LoggerSpy()

        sqliteManagerMock.queryReturn = [mockMap]
        sqliteManagerMock.insertReturn = true
        sqliteManagerMock.insertMultiplesReturn = true
        sqliteManagerMock.deleteReturn = true

        dirtyEventDao = DirtyEventSQLiteDao(sqliteManager: sqliteManagerMock, logger: loggerMock)
    }

    func testQueryShouldCallDatabaseClientQuery() {
        dirtyEventDao.queryDirtyMeetingEventItems(size: 10)
        XCTAssertEqual(sqliteManagerMock.queryCalls.filter { $0.tableName == self.tableName && $0.size == 10 }.count, 1)
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
        XCTAssertEqual(sqliteManagerMock.insertMultiplesCalls.filter { $0.tableName == self.tableName }.count, 1)
    }

    func testDeleteShouldCallDatabaseClientWrite() {
        dirtyEventDao.deleteDirtyMeetingEventsByIds(ids: [uuid!])
        XCTAssertEqual(sqliteManagerMock.deleteCalls.filter { $0.tableName == self.tableName }.count, 1)
    }
}
