//
//  SQLiteClientTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Foundation
import SQLite3
import XCTest

class SQLiteClientTests: XCTestCase {
    let tableName = "Test"
    let insertValue = "Hello"
    let insertNumber = Int64(1777)

    var sqliteDBClient: SQLiteClient?

    private let pkName = "id"
    private let dataName = "data"
    private let numName = "num"

    override func setUp() {
        let loggerMock = mock(Logger.self)

        // :memory: is needed for in memory databse
        sqliteDBClient = SQLiteClient(databaseName: ":memory:", logger: loggerMock, inMemory: true)
        createTable(tableName: tableName)
    }

    override func tearDown() {
        dropTable()
        sqliteDBClient?.close()
    }

    func createTable(tableName: String) {
        sqliteDBClient?.write(statement: "CREATE TABLE IF NOT EXISTS \(tableName) (\(pkName) INTEGER PRIMARY KEY AUTOINCREMENT, \(dataName) TEXT, \(numName) INTEGER);")
    }

    func testCreateTableWithMalformedStatementShouldFail() {
        let isCreated = sqliteDBClient?.write(statement: "CREATE TABLE IF NOT EXISTS \(tableName) (id ZZZZZ;ei PRIMARY KEY CHICKEN, \(dataName) NO KFC TODAY);")

        XCTAssertFalse(isCreated ?? true)
    }

    func testCreateTableShouldNotFailWhenCreatingExistingTable() {
        let isCreated = sqliteDBClient?.write(statement: "CREATE TABLE IF NOT EXISTS \(tableName) (\(pkName) INTEGER PRIMARY KEY AUTOINCREMENT, \(dataName) TEXT, \(numName) INTEGER);")

        XCTAssertTrue(isCreated ?? false)
    }

    func testWriteShouldInsertASingleItem() {
        let inserted = sqliteDBClient?.write(statement: getInsertStatement(),
                                             params: [insertValue, insertNumber])

        XCTAssertEqual(inserted, true)

        let result = sqliteDBClient?.query(statement: getQueryStatement())
        XCTAssertEqual(insertValue, result?[0][dataName] as? String)
        XCTAssertEqual(insertNumber, result?[0][numName] as? Int64)
    }

    func testWriteShouldInsertMultipleItems() {
        let inserted1 = sqliteDBClient?.write(statement: getInsertStatement(), params: ["Hello1", 1])
        let inserted2 = sqliteDBClient?.write(statement: getInsertStatement(), params: ["Hello2", 2])

        XCTAssertEqual(inserted1, true)
        XCTAssertEqual(inserted2, true)

        let result = sqliteDBClient?.query(statement: getQueryStatement())

        XCTAssertEqual(result?[0][dataName] as? String, "Hello1")
        XCTAssertEqual(result?[1][dataName] as? String, "Hello2")
    }

    func testWriteShouldInsertMultipleItemsWithMultipleValues() {
        let inserted = sqliteDBClient?.write(statement: "INSERT INTO \(self.tableName) (\(dataName), \(numName)) VALUES (?, ?),(?, ?);", params: ["Hello1", 1, "Hello2", 2])

        XCTAssertEqual(inserted, true)

        let result = sqliteDBClient?.query(statement: getQueryStatement())

        XCTAssertEqual(result?[0][dataName] as? String, "Hello1")
        XCTAssertEqual(result?[1][dataName] as? String, "Hello2")
    }

    func testWriteShouldFailWhenFewerParamsAreGiven() {
        let inserted = sqliteDBClient?.write(statement: getInsertStatement(), params: [])

        XCTAssertEqual(inserted, false)
    }

    func testWriteShouldFailWhenMoreParamsAreGiven() {
        let inserted = sqliteDBClient?.write(statement: getInsertStatement(), params: ["a", 5, "c"])

        XCTAssertEqual(inserted, false)
    }

    func testWriteShouldInsertMultipleItemsConcurrently() {
        let backgroundThreadEndedExpectation1 = XCTestExpectation(
            description: "The background thread 1 was ended")
        let backgroundThreadEndedExpectation2 = XCTestExpectation(
            description: "The background thread 2 was ended")

        DispatchQueue.global(qos: .userInteractive).async {
            sleep(2)
            let inserted = self.sqliteDBClient?.write(statement: self.getInsertStatement(), params: ["Hello1", 5])
            XCTAssertEqual(inserted, true)
            backgroundThreadEndedExpectation1.fulfill()
        }
        DispatchQueue.global(qos: .userInteractive).async {
            sleep(2)
            let inserted = self.sqliteDBClient?.write(statement: self.getInsertStatement(), params: ["Hello2", 2])
            XCTAssertEqual(inserted, true)
            backgroundThreadEndedExpectation2.fulfill()
        }

        wait(for: [backgroundThreadEndedExpectation1, backgroundThreadEndedExpectation2], timeout: 3)

        let result = sqliteDBClient?.query(statement: getQueryStatement(), params: nil)

        XCTAssertEqual(result?.count, 2)
    }

    func testQueryShouldBindStringAndInteger() {
        let inserted = sqliteDBClient?.write(statement: getInsertStatement(),
                                             params: [insertValue, insertNumber])

        XCTAssertEqual(inserted, true)

        let result1 = sqliteDBClient?.query(statement: "\(getQueryStatement()) LIMIT 1;", params: nil)
        let result2 = sqliteDBClient?.query(statement: "\(getQueryStatement()) WHERE id=?;", params: [result1?[0][pkName]])

        XCTAssertEqual(result1?[0][pkName] as? Int, result2?[0][pkName] as? Int)
        XCTAssertNotNil(result1?[0][dataName] as? String)
        XCTAssertEqual(result1?[0][dataName] as? String, result2?[0][dataName] as? String)

    }

    func testQueryShouldReturnEmptyWhenNoEntryFound() {
        let result = sqliteDBClient?.query(statement: "\(getQueryStatement()) WHERE id=?;", params: ["randomId"])

        XCTAssertEqual(0, result?.count)
    }

    func testDeleteShouldReturnTrueWhenNoEntryFound() {
        let result = sqliteDBClient?.write(statement: "\(getDeleteStatement()) WHERE id=?;", params: ["randomId"])

        XCTAssertTrue(result ?? false)
    }

    func testDeleteShouldReturnTrueWhenDeleteAnItem() {
        let inserted = sqliteDBClient?.write(statement: getInsertStatement(),
                                             params: [insertValue, insertNumber])

        XCTAssertTrue(inserted ?? false)

        let deleted = sqliteDBClient?.write(statement: "\(getDeleteStatement()) WHERE \(numName)=?;", params: [insertNumber])

        XCTAssertTrue(deleted ?? false)
    }

    func testInsertShouldNotThrowErrorWhenFailed() {
        dropTable()
        let inserted = sqliteDBClient?.write(statement: getInsertStatement(),
                                             params: [insertValue, insertNumber])

        XCTAssertEqual(inserted, false)
    }

    func testQueryShouldReturnEmptyListWhenFailed() {
        dropTable()
        let result1 = sqliteDBClient?.query(statement: "\(getQueryStatement()) LIMIT 10;", params: nil)

        XCTAssertEqual(result1?.count, 0)
    }

    func testDeleteShouldNotThrowErrorWhenFailed() {
        dropTable()
        let deleted = sqliteDBClient?.write(statement: getDeleteStatement())
        XCTAssertEqual(deleted, false)
    }

    private func getInsertStatement() -> String {
        return "INSERT INTO \(self.tableName) (\(dataName), \(numName)) VALUES (?, ?);"
    }

    private func getQueryStatement() -> String {
        return "SELECT \(pkName), \(dataName), \(numName) FROM \(tableName)"
    }

    private func getDeleteStatement() -> String {
        return "DELETE FROM \(tableName)"
    }

    private func dropTable() {
        sqliteDBClient?.write(statement: "DROP TABLE \(tableName);")
    }
}
