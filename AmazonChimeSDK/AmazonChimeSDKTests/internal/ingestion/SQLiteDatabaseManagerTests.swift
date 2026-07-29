//
//  SQLiteDatabaseManagerTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Cuckoo
import XCTest

class SQLiteDatabaseManagerTests: XCTestCase {
    private var sqliteDatabaseManager: SQLiteDatabaseManager!
    private var sqliteClient: MockDatabaseClient!
    private let contentValue = [
        "id": "hello",
        "data": "world"
    ]
    private let tableName = "test"

    override func setUp() {
        sqliteClient = MockDatabaseClient().withEnabledDefaultImplementation(DatabaseClientStub())
        stub(sqliteClient) { stub in
            when(stub.query(statement: any(), params: any())).thenReturn([])
            when(stub.write(statement: any(), params: any())).thenReturn(true)
        }
        sqliteDatabaseManager = SQLiteDatabaseManager(sqliteClient: sqliteClient)
    }

    func testInsertShouldInvokeClientWrite() {
        sqliteDatabaseManager.insert(tableName: tableName, contentValue: contentValue)
        verify(sqliteClient, times(1)).write(statement: any(), params: any())
    }

    func testExecuteShouldInvokeClientWrite() {
        sqliteDatabaseManager.execute(statement: "example statement")
        verify(sqliteClient, times(1)).write(statement: any(), params: any())
    }

    func testInsertMultipleShouldInvokeClientWrite() {
        sqliteDatabaseManager.insertMultiples(tableName: tableName, contentValues: [contentValue])
        verify(sqliteClient, times(1)).write(statement: any(), params: any())
    }

    func testQueryShouldInvokeClientQuery() {
        sqliteDatabaseManager.query(tableName: tableName, size: 5)
        verify(sqliteClient, times(1)).query(statement: any(), params:  any())
    }
}
