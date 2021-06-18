//
//  SQLiteDatabaseManagerTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Mockingbird
import XCTest

class SQLiteDatabaseManagerTests: XCTestCase {
    private var sqliteDatabaseManager: SQLiteDatabaseManager!
    private var sqliteClient: DatabaseClientMock!
    private let contentValue = [
        "id": "hello",
        "data": "world"
    ]
    private let tableName = "test"

    override func setUp() {
        sqliteClient = mock(DatabaseClient.self)
        given(sqliteClient.query(statement: any(), params: any())).willReturn([])
        given(sqliteClient.write(statement: any(), params: any())).willReturn(true)
        sqliteDatabaseManager = SQLiteDatabaseManager(sqliteClient: sqliteClient)
    }

    func testInsertShouldInvokeClientWrite() {
        sqliteDatabaseManager.insert(tableName: tableName, contentValue: contentValue)
        verify(sqliteClient.write(statement: any(), params: any())).wasCalled(1)
    }

    func testExecuteShouldInvokeClientWrite() {
        sqliteDatabaseManager.execute(statement: "example statement")
        verify(sqliteClient.write(statement: any(), params: any())).wasCalled(1)
    }

    func testInsertMultipleShouldInvokeClientWrite() {
        sqliteDatabaseManager.insertMultiples(tableName: tableName, contentValues: [contentValue])
        verify(sqliteClient.write(statement: any(), params: any())).wasCalled(1)
    }

    func testQueryShouldInvokeClientQuery() {
        sqliteDatabaseManager.query(tableName: tableName, size: 5)
        verify(sqliteClient.query(statement: any(), params:  any())).wasCalled(1)
    }
}
