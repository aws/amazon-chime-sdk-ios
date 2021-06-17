//
//  SQLiteDatabaseManager.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

class SQLiteDatabaseManager: DatabaseManager {
    private let sqliteClient: DatabaseClient

    init(sqliteClient: DatabaseClient) {
        self.sqliteClient = sqliteClient
    }

    func clear(tableName: String) {
        sqliteClient.write(statement: "DELETE FROM \(tableName)")
    }

    func delete(tableName: String, ids: [String]) -> Bool {
        let whereClause = ids.map { (_) -> String in
            "?"
        }.joined(separator: ",")
        return sqliteClient.write(statement: "DELETE FROM \(tableName) WHERE id in (\(whereClause))", params: ids)
    }

    func execute(statement: String) {
        sqliteClient.write(statement: statement)
    }

    func insert(tableName: String, contentValue: [String: Any]) -> Bool {
        var params: [Any?] = []
        var values: [String] = []
        let keys = contentValue.keys.map { (key) -> String in
            params.append(contentValue[key])
            values.append("?")
            return key
        }.joined(separator: ",")

        return sqliteClient.write(statement: "INSERT INTO \(tableName) (\(keys)) VALUES (\(values.joined(separator: ",")))", params: params)
    }

    func insertMultiples(tableName: String, contentValues: [[String: Any]]) -> Bool {
        if contentValues.isEmpty {
            return true
        }
        var values: [String] = []
        var params: [Any?] = []

        // We are creating INSER INTO (column1...) VALUES (?, ?, ?), (?, ?, ?) ...
        let keys = Array(contentValues[0].keys)

        // http://www.sqlite.org/releaselog/3_7_11.html
        contentValues.forEach { (contentValue) in
            values.append("(\(contentValue.map { _ in "?" }.joined(separator: ",")))")
            for key in keys {
                params.append(contentValue[key])
            }
        }

        return sqliteClient.write(statement: "INSERT INTO \(tableName) (\(keys.joined(separator: ","))) VALUES \(values.joined(separator: ","));", params: params)
    }

    func query(tableName: String, size: Int) -> [[String: Any?]] {
        return sqliteClient.query(statement: "SELECT * FROM \(tableName) LIMIT ?", params: [size])
    }
}
