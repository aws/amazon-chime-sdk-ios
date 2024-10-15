//
//  DictionaryExtension.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// This is helper function to convert dictionary into JSON string that can be used in
/// `EventAnalyticsObserver.eventDidReceive` callback to convert attributes
/// into JSON string. Calling `attributes.text()`  will returns string
public extension Dictionary where Key == AnyHashable, Value: Any {
    func toJsonString() -> String {
        var jsonDict = [String: String]()
        self.forEach { (key, value) in
            jsonDict[String(describing: key)] = String(describing: value)
        }
        let data = try? JSONSerialization.data(withJSONObject: jsonDict, options: [])
        if let jsonData = data {
            return String(data: jsonData, encoding: .utf8) ?? ""
        }
        return ""
    }
}

/// This is helper function to convert dictionary into JSON string that can be used in
/// `EventAnalyticsObserver.eventDidReceive` callback to convert attributes
/// into JSON string. Calling `attributes.text()`  will returns string
@objc public extension NSDictionary {
    func toJsonString() -> String {
        if let dict = self as? [AnyHashable: Any] {
            return dict.toJsonString()
        }
        return ""
    }
}

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

extension Dictionary where Key: Any, Value: Any {
    func toStringDict() -> [String: String] {
        var jsonDict = [String: String]()
        self.forEach { (key, value) in
            jsonDict[String(describing: key)] = String(describing: value)
        }
        return jsonDict
    }
}
