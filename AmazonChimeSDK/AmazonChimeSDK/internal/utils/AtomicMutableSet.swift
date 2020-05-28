//
//  AtomicMutableSet.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

class AtomicMutableSet {
    private let lock = NSLock()
    private let set = NSMutableSet()

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

    func forEach(_ body: (Any) throws -> Void) rethrows {
        lock.lock()
        defer { lock.unlock() }
        try set.forEach(body)
    }
}
