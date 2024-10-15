//
//  EventSQLiteDao.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

class EventSQLiteDao: EventDao {
    private let sqliteManager: DatabaseManager
    private let logger: Logger
    private let tableName = "Events"

    init(sqliteManager: DatabaseManager, logger: Logger) {
        self.sqliteManager = sqliteManager
        self.logger = logger

        sqliteManager.execute(statement: "CREATE TABLE IF NOT EXISTS \(tableName) (id TEXT PRIMARY KEY, data TEXT)")
    }

    func queryMeetingEventItems(size: Int) -> [MeetingEventItem] {
        let events = sqliteManager.query(tableName: tableName, size: size)
        return events.compactMap { (event: [String: Any?]) -> MeetingEventItem? in
            if let id = event["id"] as? String,
               let dataStr = event["data"] as? String,
               let data = dataStr.data(using: .utf8),
               // TODO: This will skip the item from processing by EventBuffer if decoding fails, should always return the event so that EventBuffer can delete it from database.
               let jsonSerilizedData = try? JSONDecoder().decode(IngestionMeetingEvent.self, from: data) {
                return MeetingEventItem(id: id, data: jsonSerilizedData)
            }

            return nil
        }
    }

    func insertMeetingEvent(event: MeetingEventItem) -> Bool {
        if let data = try? JSONEncoder().encode(event.data),
           let dataStr = String(data: data, encoding: .utf8) {
            let contentValue = [
                "id": event.id,
                "data": dataStr
            ]
            return sqliteManager.insert(tableName: tableName, contentValue: contentValue)
        }
        return false
    }

    func deleteMeetingEventsByIds(ids: [String]) -> Bool {
        return sqliteManager.delete(tableName: tableName, ids: ids)
    }
}
