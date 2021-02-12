//
//  ConcurrentMutableSet.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers class ConcurrentMutableSet {
    private let lock = NSRecursiveLock()
    private let set = NSMutableSet()
    var count: Int {
        return set.count
    }

    func add(_ object: Any) {
        lock.lock()
        defer { lock.unlock() }
        set.add(object)
    }

    func remove(_ object: Any) {
        lock.lock()
        defer { lock.unlock() }
        set.remove(object)
    }
    
    func removeAll() {
        lock.lock()
        defer { lock.unlock() }
        set.removeAllObjects()
    }

    func contains(_ object: Any) -> Bool {
        return set.contains(object)
    }

    func forEach(_ body: (Any) throws -> Void) rethrows {
        lock.lock()
        defer { lock.unlock() }
        try set.forEach(body)
    }
}
