//
//  AnyCodable.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

public struct AnyCodable: Codable {

    private let _encode: (Encoder) throws -> Void
    private let valueType: Any.Type
    let value: Any
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode(Bool.self) {
            self.init(value)
        } else if let value = try? container.decode(Int.self) {
            self.init(value)
        } else if let value = try? container.decode(Double.self) {
            self.init(value)
        } else if let value = try? container.decode(String.self) {
            self.init(value)
        } else if let value = try? container.decode([AnyCodable].self) {
            self.init(value)
        } else if let value = try? container.decode([String: AnyCodable].self) {
            self.init(value)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Value cannot be decoded")
        }
    }
    
    public init(booleanLiteral value: Bool) {
        self.init(value)
    }
    
    public init(floatLiteral value: Double) {
        self.init(value)
    }
    
    public init(integerLiteral value: Int) {
        self.init(value)
    }
    
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
    
    public init(arrayLiteral elements: AnyCodable...) {
        self.init(elements)
    }
    
    public init(dictionaryLiteral elements: (String, AnyCodable)...) {
        let items = [String: AnyCodable].init(elements,
                                              uniquingKeysWith: { (_, last) in last })
        self.init(items)
    }
    
    public init<T: Encodable>(_ item: T) {
        _encode = item.encode
        self.value = item
        self.valueType = type(of: item)
    }
    
    public init<T: Encodable>(_ item: [T]) {
        _encode = item.encode
        self.value = item
        self.valueType = type(of: item)
    }
    
    public init<T: Encodable>(_ item: [String: T]) {
        _encode = item.encode
        self.value = item
        self.valueType = type(of: item)
    }
    
    public init?(_ item: Any?) {
        guard let item = item else {
            return nil
        }
        if let boolItem = item as? Bool {
            self.init(boolItem)
        } else if let doubleItem = item as? Double {
            self.init(doubleItem)
        } else if let doubleItem = item as? Float {
            self.init(doubleItem)
        } else if let intItem = item as? Int {
            self.init(intItem)
        } else if let intItem = item as? Int8 {
            self.init(intItem)
        } else if let intItem = item as? Int16 {
            self.init(intItem)
        } else if let intItem = item as? Int32 {
            self.init(intItem)
        } else if let intItem = item as? Int64 {
            self.init(intItem)
        } else if let intItem = item as? UInt {
            self.init(intItem)
        } else if let intItem = item as? UInt8 {
            self.init(intItem)
        } else if let intItem = item as? UInt16 {
            self.init(intItem)
        } else if let intItem = item as? UInt32 {
            self.init(intItem)
        } else if let intItem = item as? UInt64 {
            self.init(intItem)
        } else if let strItem = item as? String {
            self.init(strItem)
        } else if let arrItem = item as? [AnyCodable] {
            self.init(arrItem)
        } else if let dictItem = item as? [String: AnyCodable] {
            self.init(dictItem)
        } else {
            return nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
    
    var int64Value:Int64? {
        if self.valueType == Int64.self {
            return self.value as? Int64
        }
        // Only handle `Int` since decoder does not handle other Int types
        if self.valueType == Int.self,
            let intValue = self.value as? Int {
            return Int64(intValue)
        }
        return nil
    }
}

extension AnyCodable: ExpressibleByBooleanLiteral {}
extension AnyCodable: ExpressibleByIntegerLiteral {}
extension AnyCodable: ExpressibleByFloatLiteral {}
extension AnyCodable: ExpressibleByStringLiteral {}
extension AnyCodable: ExpressibleByStringInterpolation {}
extension AnyCodable: ExpressibleByArrayLiteral {}
extension AnyCodable: ExpressibleByDictionaryLiteral {}
