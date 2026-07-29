//
//  SQLiteDatabaseManagerTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class SQLiteDatabaseManagerTests: XCTestCase {
    private var sqliteDatabaseManager: SQLiteDatabaseManager!
    private var sqliteClient: DatabaseClientSpy!
    private let contentValue = [
        "id": "hello",
        "data": "world"
    ]
    private let tableName = "test"

    override func setUp() {
        sqliteClient = DatabaseClientSpy()
        sqliteClient.queryReturn = []
        sqliteClient.writeReturn = true
        sqliteDatabaseManager = SQLiteDatabaseManager(sqliteClient: sqliteClient)
    }

    func testInsertShouldInvokeClientWrite() {
        sqliteDatabaseManager.insert(tableName: tableName, contentValue: contentValue)
        XCTAssertEqual(sqliteClient.writeCalls.count, 1)
    }

    func testExecuteShouldInvokeClientWrite() {
        sqliteDatabaseManager.execute(statement: "example statement")
        XCTAssertEqual(sqliteClient.writeCalls.count, 1)
    }

    func testInsertMultipleShouldInvokeClientWrite() {
        sqliteDatabaseManager.insertMultiples(tableName: tableName, contentValues: [contentValue])
        XCTAssertEqual(sqliteClient.writeCalls.count, 1)
    }

    func testQueryShouldInvokeClientQuery() {
        sqliteDatabaseManager.query(tableName: tableName, size: 5)
        XCTAssertEqual(sqliteClient.queryCalls.count, 1)
    }
}
