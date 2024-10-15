//
//  AnyCodableTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class AnyCodableTests: XCTestCase {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
}

// MARK: Decoder tests
extension AnyCodableTests{
    
    func testAnyCodableCanInitBoolFromDecoder() {
        let data = true
        let codableData = AnyCodable(data)
        guard let decodedData = encodeAndDecode(data: codableData) else {
            XCTFail("Failed to encode/decode data")
            return
        }
        XCTAssertEqual(data, decodedData.value as? Bool)
    }
    
    func testAnyCodableCanInitIntFromDecoder() {
        let data = Int(123)
        let codableData = AnyCodable(data)
        guard let decodedData = encodeAndDecode(data: codableData) else {
            XCTFail("Failed to encode/decode data")
            return
        }
        XCTAssertEqual(data, decodedData.value as? Int)
    }
    
    func testAnyCodableCanInitDoubleFromDecoder() {
        let data = Double(123.456)
        let codableData = AnyCodable(data)
        guard let decodedData = encodeAndDecode(data: codableData) else {
            XCTFail("Failed to encode/decode data")
            return
        }
        XCTAssertEqual(data, decodedData.value as? Double)
    }
    
    func testAnyCodableCanInitStringFromDecoder() {
        let data = String("test string")
        let codableData = AnyCodable(data)
        guard let decodedData = encodeAndDecode(data: codableData) else {
            XCTFail("Failed to encode/decode data")
            return
        }
        XCTAssertEqual(data, decodedData.value as? String)
    }
    
    func testAnyCodableCanInitArrayFromDecoder() {
        let data:[AnyCodable] = [1,2,3]
        guard let decodedData = encodeAndDecode(data: data) else {
            XCTFail("Failed to encode/decode data")
            return
        }
        XCTAssertEqual(data[0].value as? Int, decodedData[0].value as? Int)
    }
    
    func testAnyCodableCanInitDictFromDecoder() {
        let data:[String: AnyCodable] = ["a":1, "b":2, "c":3]
        guard let decodedData = encodeAndDecode(data: data) else {
            XCTFail("Failed to encode/decode data")
            return
        }
        XCTAssertEqual(data["a"]?.value as? Int, decodedData["a"]?.value as? Int)
    }
    
    private func encodeAndDecode(data: AnyCodable) -> AnyCodable? {
        guard let encodedData = try? encoder.encode(data) else {
            return nil
        }
        guard let decodedData = try? decoder.decode(AnyCodable.self, from: encodedData) else {
            return nil
        }
        return decodedData
    }
    
    private func encodeAndDecode(data: [AnyCodable]) -> [AnyCodable]? {
        guard let encodedData = try? encoder.encode(data) else {
            return nil
        }
        guard let decodedData = try? decoder.decode([AnyCodable].self, from: encodedData) else {
            return nil
        }
        return decodedData
    }
    
    private func encodeAndDecode(data: [String: AnyCodable]) -> [String: AnyCodable]? {
        guard let encodedData = try? encoder.encode(data) else {
            return nil
        }
        guard let decodedData = try? decoder.decode([String: AnyCodable].self, from: encodedData) else {
            return nil
        }
        return decodedData
    }
}

// MARK: Init tests
extension AnyCodableTests {
    
    func testInitBoolLiteral() {
        let data = true
        let codableData = AnyCodable(booleanLiteral: data)
        XCTAssertEqual(codableData.value as? Bool, data)
    }
    
    func testInitFloatLiteral() {
        let data = Double(123.456)
        let codableData = AnyCodable(floatLiteral: data)
        XCTAssertEqual(codableData.value as? Double, data)
    }
    
    func testInitIntLiteral() {
        let data = Int(123)
        let codableData = AnyCodable(integerLiteral: data)
        XCTAssertEqual(codableData.value as? Int, data)
    }
    
    func testInitStringLiteral() {
        let data = String("abc")
        let codableData = AnyCodable(stringLiteral: data)
        XCTAssertEqual(codableData.value as? String, data)
    }
    
    func testInitArrayLiteral() {
        let codableData = AnyCodable(arrayLiteral: "a", "b", "c")
        let value = codableData.value as? [AnyCodable]
        XCTAssertEqual(value?[0].value as? String, "a")
        XCTAssertEqual(value?[1].value as? String, "b")
        XCTAssertEqual(value?[2].value as? String, "c")
    }
    
    func testInitDictLiteral() {
        let codableData = AnyCodable(dictionaryLiteral:
            ("a", AnyCodable(1)),
            ("b", AnyCodable(2)),
            ("c", AnyCodable(3))
        )
        let value = codableData.value as? [String: AnyCodable]
        XCTAssertEqual(value?["a"]?.value as? Int, 1)
        XCTAssertEqual(value?["b"]?.value as? Int, 2)
        XCTAssertEqual(value?["c"]?.value as? Int, 3)
    }
    
    func testBoolAnyInitShouldInitialize() {
        let data: Any? = true
        XCTAssertNotNil(AnyCodable(data))
    }
    
    func testDoubleAnyInitShouldInitialize() {
        let data: Any? = Float(123.456)
        XCTAssertNotNil(AnyCodable(data))
    }
    
    func testFloatAnyInitShouldInitialize() {
        let data: Any? = Float(123.456)
        XCTAssertNotNil(AnyCodable(data))
    }
    
    func testIntAnyInitShouldInitialize() {
        let data: Any? = Int(123)
        XCTAssertNotNil(AnyCodable(data))
    }
    
    func testInt8AnyInitShouldInitialize() {
        let data: Any? = Int8(123)
        XCTAssertNotNil(AnyCodable(data))
    }
    
    func testInt16AnyInitShouldInitialize() {
        let data: Any? = Int16(123)
        XCTAssertNotNil(AnyCodable(data))
    }
    
    func testInt32AnyInitShouldInitialize() {
        let data: Any? = Int32(123)
        XCTAssertNotNil(AnyCodable(data))
    }
    
    func testInt64AnyInitShouldInitialize() {
        let data: Any? = Int64(123)
        XCTAssertNotNil(AnyCodable(data))
    }
    
    func testUIntAnyInitShouldInitialize() {
        let data: Any? = UInt(123)
        XCTAssertNotNil(AnyCodable(data))
    }
    
    func testUInt8AnyInitShouldInitialize() {
        let data: Any? = UInt8(123)
        XCTAssertNotNil(AnyCodable(data))
    }
    
    func testUInt16AnyInitShouldInitialize() {
        let data: Any? = UInt16(123)
        XCTAssertNotNil(AnyCodable(data))
    }
    
    func testUInt32AnyInitShouldInitialize() {
        let data: Any? = UInt32(123)
        XCTAssertNotNil(AnyCodable(data))
    }
    
    func testUInt64AnyInitShouldInitialize() {
        let data: Any? = UInt64(123)
        XCTAssertNotNil(AnyCodable(data))
    }
    
    func testStringAnyInitShouldInitialize() {
        let data: Any? = String("abc")
        XCTAssertNotNil(AnyCodable(data))
    }
    
    func testArrayAnyInitShouldInitialize() {
        let data: Any? = [AnyCodable("a"), AnyCodable("b"), AnyCodable("c")]
        XCTAssertNotNil(AnyCodable(data))
    }
    
    func testDictAnyInitShouldInitialize() {
        let data: Any? = ["a": AnyCodable(1), "b": AnyCodable(2), "c": AnyCodable(3)]
        XCTAssertNotNil(AnyCodable(data))
    }
}

// MARK: Int cast helper method tests
extension AnyCodableTests {
    
    func testInt64ValueShouldReturnValueIfAnyCodableIsInt64() {
        let data = Int64(123)
        let codableData = AnyCodable(data)
        XCTAssertEqual(data, codableData.int64Value)
    }
    
    func testInt64ValueShouldReturnValueIfAnyCodableIsInt() {
        let data = Int(123)
        let codableData = AnyCodable(data)
        XCTAssertEqual(Int64(data), codableData.int64Value)
    }
    
    func testInt64ValueShouldReturnNilIfAnyCodableIsNotInt64OrInt() {
        let data = String("123")
        let codableData = AnyCodable(data)
        XCTAssertNil(codableData.int64Value)
    }
}
