//
//  Dictionary.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

extension Dictionary where Key: Comparable, Value: Equatable {
    func subtracting(dict: [Key: Value]) -> [Key: Value] {
        let selfEntries = filter {
            dict[$0.0] != self[$0.0]
        }
        return selfEntries.reduce([Key: Value]()) { (result, entry) -> [Key: Value] in
            var map = result
            map[entry.0] = entry.1
            return map
        }
    }
}
