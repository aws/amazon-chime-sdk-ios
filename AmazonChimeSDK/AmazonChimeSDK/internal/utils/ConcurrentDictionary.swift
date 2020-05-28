//
//  ConcurrentDictionary.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers class ConcurrentDictionary<Key: Hashable, Value> {
    private let lock = NSRecursiveLock()
    private var dict: [Key: Value] = [:]

    subscript(key: Key) -> Value? {
        get {
            lock.lock()
            defer { lock.unlock() }
            return dict[key]
        }
        set(value) {
            lock.lock()
            defer { lock.unlock() }
            dict[key] = value
        }
    }

    func forEach(_ body: ((key: Key, value: Value)) throws -> Void) rethrows {
        lock.lock()
        defer { lock.unlock() }
        try dict.forEach(body)
    }

    func sorted(by order: ((key: Key, value: Value), (key: Key, value: Value)) throws -> Bool)
        rethrows -> [(key: Key, value: Value)] {
        lock.lock()
        defer { lock.unlock() }
        let sorted = try dict.sorted(by: order)
        return sorted
    }

    func getShallowDictCopy() -> [Key: Value] {
        lock.lock()
        defer { lock.unlock() }
        let copyOfDict = dict
        return copyOfDict
    }
}
