//
//  DatabaseClient.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

protocol DatabaseClient {
    func close() -> Bool
    func query(statement: String, params: [Any?]?) -> [[String: Any?]]
    func write(statement: String, params: [Any?]?) -> Bool
}

extension DatabaseClient {
    func query(statement: String, params: [Any?]? = nil) -> [[String: Any?]] {
        return query(statement: statement, params: params)
    }

    func write(statement: String, params: [Any?]? = nil) -> Bool {
        return write(statement: statement, params: params)
    }
}
