//
//  DirtyEventSQLiteDao.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

class DirtyEventSQLiteDao: DirtyEventDao {
    private let sqliteManager: DatabaseManager
    private let logger: Logger
    private let tableName = "DirtyEvents"

    init(sqliteManager: DatabaseManager, logger: Logger) {
        self.sqliteManager = sqliteManager
        self.logger = logger

        sqliteManager.execute(statement: "CREATE TABLE IF NOT EXISTS \(tableName) (id TEXT PRIMARY KEY, data TEXT, ttl INTEGER)")

    }
    func queryDirtyMeetingEventItems(size: Int) -> [DirtyMeetingEventItem] {
        let events = sqliteManager.query(tableName: tableName, size: size)

        // Compact map only returns non-nil elements
        return events.compactMap { (event: [String: Any?]) -> DirtyMeetingEventItem? in
            if let id = event["id"] as? String,
               let dataStr = event["data"] as? String,
               let ttl = event["ttl"] as? Int64,
               let data = dataStr.data(using: .utf8),
               let jsonSerilizedData = try? JSONDecoder().decode(IngestionMeetingEvent.self, from: data) {
                return DirtyMeetingEventItem(id: id, data: jsonSerilizedData, ttl: ttl)
            }

            return nil
        }
    }

    func deleteDirtyMeetingEventsByIds(ids: [String]) -> Bool {
        return sqliteManager.delete(tableName: tableName, ids: ids)
    }

    func insertDirtyMeetingEventItems(dirtyEvents: [DirtyMeetingEventItem]) -> Bool {
        let contentValues = dirtyEvents.enumerated().compactMap { (index, dirtyEvent) -> [String: Any]? in
            if let data = try? JSONEncoder().encode(dirtyEvent.data),
               let dataStr = String(data: data, encoding: .utf8) {
                return [
                    "id": dirtyEvent.id,
                    "data": dataStr,
                    "ttl": dirtyEvent.ttl
                ]
            }

            return nil
        }
        return sqliteManager.insertMultiples(tableName: tableName, contentValues: contentValues)
    }
}
