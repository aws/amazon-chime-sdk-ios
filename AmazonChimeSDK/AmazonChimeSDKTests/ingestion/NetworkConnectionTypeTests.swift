//
//  NetworkConnectionTypeTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class NetworkConnectionTypeTests: XCTestCase {
    func testDescriptionShouldMatch() {
        XCTAssertEqual(NetworkConnectionType.wifi.description, "Wifi")
        XCTAssertEqual(NetworkConnectionType.cellular.description, "Cellular")
        XCTAssertEqual(NetworkConnectionType.wiredEthernet.description, "Ethernet")
        XCTAssertEqual(NetworkConnectionType.other.description, "Other")
        XCTAssertEqual(NetworkConnectionType.none.description, "None")
        XCTAssertEqual(NetworkConnectionType.unknown.description, "Unknown")
    }
}
