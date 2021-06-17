//
//  SQLiteClient.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SQLite3

class SQLiteClient: DatabaseClient {
    /// Content pointer is constant and will never change
    let sqliteStatic = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    /// Content will likely change in the near future and that SQLite should make its own private copy of the content before returning
    let sqliteTransient = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    /// Whether mutex is enabled in compile flag for SQLite
    let mutexDisabled: Int32 = 0

    private let queue = DispatchQueue(label: "databaseQueue")

    /// A pointer to the database instance
    private var database: OpaquePointer?
    private var logger: Logger?

    /// SQLite has two ways to handle database. One in memory and one with file.
    /// See https://sqlite.org/inmemorydb.html for more details.
    /// This tells whether SQLite runs in memory (not persistent) or in file
    private var inMemory = false

    init(databaseName: String, logger: Logger?, inMemory: Bool = false) {
        self.logger = logger
        self.inMemory = inMemory

        // Check if sqlite3 is thread-safe
        // SQLITE_THREADSAFE=1 or =2 then mutexes are enabled by default
        if sqlite3_threadsafe() == mutexDisabled {
            logger?.fault(msg: "Sqlite3 is not thread-safe... it can cause issue when accessed in multiple threads")
        }

        open(databaseName: databaseName)
    }

    /// Open database. This should create database if not exist.
    /// - Parameter databaseName: name of database to create/open
    /// - Returns: whether opening the database was successful or not
    private func open(databaseName: String) -> Bool {
        // In Memory
        var path = ":memory:"
        if !inMemory {
            let filePath = try? FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(databaseName)
            guard let databasePath = filePath else {
                logger?.error(msg: "filePath is nil.")
                return false
            }
            path = databasePath.path
        }

        guard sqlite3_open(path, &database) == SQLITE_OK else {
            logger?.error(msg: "Unable to open database.")
            // Need to close if there is error
            // https://www.sqlite.org/c3ref/open.html
            close()
            return false
        }
        return true
    }

    /// Close database.
    /// - Returns: whether closing database was successful or not
    func close() -> Bool {
        guard let currentDb = database else {
            return false
        }
        // TODO: make it more robust
        let closed = sqlite3_close(currentDb)
        if closed != SQLITE_OK {
            logger?.error(msg: "Unable to close SQLiteDB")
        }

        return closed == SQLITE_OK
    }

    /// Handles SELECT statement.
    /// - Parameters:
    ///   - statement: SELECT statement
    ///   - params: parameters
    /// - Returns: Results read from table
    func query(statement: String, params: [Any?]? = nil) -> [[String: Any?]] {
        var queryResults: [[String: Any?]] = []
        queue.sync {
            let preparedStatement = prepareStatement(statement: statement, params: params)
            if preparedStatement == nil {
                return
            }
            var resp = sqlite3_step(preparedStatement)
            while resp == SQLITE_ROW {
                let columnCount = sqlite3_column_count(preparedStatement)
                var queryResult: [String: Any?] = [:]
                for index in 0 ..< columnCount {
                    let columnName = String(cString: sqlite3_column_name(preparedStatement, index))
                    queryResult[columnName] = retrieveColumn(preparedStatement: preparedStatement, index: Int(index))
                }
                queryResults.append(queryResult)
                resp = sqlite3_step(preparedStatement)
            }
            sqlite3_finalize(preparedStatement)
        }

        return queryResults
    }

    /// This is used to either create/insert/update query such as `CREATE ..., UPDATE SET, INSERT INTO`.
    /// - Parameters:
    ///   - statement: statement to run
    ///   - params: parameters
    /// - Returns: whether given query was successful or not
    func write(statement: String, params: [Any?]? = nil) -> Bool {
        queue.sync {
            let preparedStatement = prepareStatement(statement: statement, params: params)
            if preparedStatement == nil {
                return false
            }
            let resp = sqlite3_step(preparedStatement)
            sqlite3_finalize(preparedStatement)
            return resp == SQLITE_DONE
        }
    }

    /// Prepare a statement and bind parameters if neccessary
    /// For instance, if you have query `INSERT INTO tablename(id, name) VALUES(?, ?)` and
    /// pass parameters of 1, "myName." It should construct `INSERT INTO tablename(id, name) VALUES(1, "myName")`
    /// - Parameters:
    ///   - statement: SQL statement
    ///   - params: parameters to bind
    /// - Returns: a pointer to prepared statement.
    private func prepareStatement(statement: String, params: [Any?]?) -> OpaquePointer? {
        guard let currentDb = database else {
            logger?.error(msg: "No database initialized")
            return nil
        }
        // Prepare statement
        var preparedStatement: OpaquePointer?
        let sqlStatement = statement.cString(using: .utf8)

        // Handle failure
        if sqlite3_prepare_v2(currentDb, sqlStatement, -1, &preparedStatement, nil) != SQLITE_OK {
            sqlite3_finalize(preparedStatement)
            let errmsg = String(cString: sqlite3_errmsg(database))
            logger?.error(msg: "Unable to execute statement - \(statement): \(errmsg)")
            return nil
        }

        let givenParameterCount = params?.count ?? 0
        let paramsCount = sqlite3_bind_parameter_count(preparedStatement)
        if Int(paramsCount) != givenParameterCount {
            sqlite3_finalize(preparedStatement)
            logger?.error(msg: "Parameter counts does not match given: \(givenParameterCount), required: \(paramsCount)")
            return nil
        }

        if let params = params, !bindStatement(preparedStatement: preparedStatement, params: params) {
            return nil
        }

        return preparedStatement
    }

    /// Bind the preparement statement with parameters given.
    /// - Parameters:
    ///   - preparedStatement: prepared statement pointer
    ///   - params: parameters to bind
    /// - Returns: whether bind was successful or not
    private func bindStatement(preparedStatement: OpaquePointer?, params: [Any?]) -> Bool {
        for (index, param) in params.enumerated() {
            // Index for binding starts with 1
            let indexInInt32 = Int32(index + 1)
            var bindResult = SQLITE_OK
            switch param {
            case let paramString as String:
                // See https://sqlite.org/forum/info/d892850574659aea for why using
                // SQLITE_TRANSIENT
                bindResult = sqlite3_bind_text(preparedStatement, indexInInt32, paramString, -1, sqliteTransient)
            case let paramDate as Date:
                let fmt = DateFormatter()
                bindResult = sqlite3_bind_text(preparedStatement, indexInInt32, fmt.string(from: paramDate), -1, sqliteTransient)
            case let paramInt as Int:
                bindResult = sqlite3_bind_int64(preparedStatement, indexInInt32, Int64(paramInt))
            case let paramInt as Int8:
                bindResult = sqlite3_bind_int(preparedStatement, indexInInt32, Int32(paramInt))
            case let paramInt as Int16:
                bindResult = sqlite3_bind_int(preparedStatement, indexInInt32, Int32(paramInt))
            case let paramInt as Int32:
                bindResult = sqlite3_bind_int(preparedStatement, indexInInt32, Int32(paramInt))
            case let paramInt64 as Int64:
                bindResult = sqlite3_bind_int64(preparedStatement, indexInInt32, paramInt64)
            case let paramDouble as Double:
                bindResult = sqlite3_bind_double(preparedStatement, indexInInt32, paramDouble)
            case let paramFloat as Float:
                bindResult = sqlite3_bind_double(preparedStatement, indexInInt32, Double(paramFloat))
            case let paramData as NSData:
                bindResult = sqlite3_bind_blob(preparedStatement, indexInInt32, paramData.bytes, Int32(paramData.length), sqliteTransient)
            case nil:
                bindResult = sqlite3_bind_null(preparedStatement, indexInInt32)
            default:
                sqlite3_finalize(preparedStatement)
                logger?.error(msg: "Unsupported data type")
                return false
            }

            if bindResult != SQLITE_OK {
                sqlite3_finalize(preparedStatement)
                logger?.error(msg: "Unable to bind a paramter")
                return false
            }
        }
        return true
    }

    /// Retreive data for each column.
    /// For instance, if database contains two column id, name, and given index is 0
    /// it should retrieve id.
    /// - Parameters:
    ///   - preparedStatement: a pointer to prepared statement
    ///   - index: index of column to get value
    /// - Returns: Data inside the prepared statement
    private func retrieveColumn(preparedStatement: OpaquePointer?, index: Int) -> Any? {
        let indexInInt32 = Int32(index)
        switch sqlite3_column_type(preparedStatement, indexInInt32) {
        case SQLITE_BLOB:
            if let pointer = sqlite3_column_blob(preparedStatement, indexInInt32) {
                let size = sqlite3_column_bytes(preparedStatement, indexInInt32)
                return NSData(bytes: pointer, length: Int(size))
            }

            return nil
        case SQLITE_FLOAT:
            return sqlite3_column_double(preparedStatement, Int32(index)) as Double
        case SQLITE_INTEGER:
            return sqlite3_column_int64(preparedStatement, indexInInt32) as Int64
        case SQLITE_NULL:
            return nil
        case SQLITE_TEXT:
            return String(cString: UnsafePointer(sqlite3_column_text(preparedStatement, indexInInt32)))
        default:
            logger?.error(msg: "Unsupported type")
            return nil
        }
    }
}
