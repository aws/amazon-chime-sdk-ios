//
//  SQLiteClientFileTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Foundation
import SQLite3
import XCTest

class SQLiteClientFileTests: SQLiteClientTests {
    override func setUp() {
        let loggerMock = mock(Logger.self)

        sqliteDBClient = SQLiteClient(databaseName: "db_in_file.db", logger: loggerMock)
        createTable(tableName: tableName)
    }

    override func tearDown() {
        sqliteDBClient?.write(statement: "DELETE FROM \(tableName)")
        sqliteDBClient?.close()
    }
}
