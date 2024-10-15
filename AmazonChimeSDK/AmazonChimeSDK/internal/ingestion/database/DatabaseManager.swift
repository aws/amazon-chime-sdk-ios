//
//  DatabaseManager.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

protocol DatabaseManager {
    func query(tableName: String, size: Int) -> [[String: Any?]]
    func insert(tableName: String, contentValue: [String: Any]) -> Bool
    func insertMultiples(tableName: String, contentValues: [[String: Any]]) -> Bool
    func delete(tableName: String, ids: [String]) -> Bool
    func execute(statement: String)
    func clear(tableName: String)
}
