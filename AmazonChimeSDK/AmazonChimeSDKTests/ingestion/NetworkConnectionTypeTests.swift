//
//  NetworkConnectionTypeTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Network
import XCTest

final class NetworkConnectionTypeTests: XCTestCase {
    
    // MARK: - NetworkConnectionType Initialization Tests
    
    func testNetworkConnectionType_WhenPathStatusNotSatisfied_ShouldReturnNone() {
        // Given
        let path = createMockPath(status: .unsatisfied, interfaceTypes: [])
        
        // When
        let connectionType = NetworkConnectionType(from: path)
        
        // Then
        XCTAssertEqual(connectionType, .none)
    }
    
    func testNetworkConnectionType_WhenPathUsesWifi_ShouldReturnWifi() {
        // Given
        let path = createMockPath(status: .satisfied, interfaceTypes: [.wifi])
        
        // When
        let connectionType = NetworkConnectionType(from: path)
        
        // Then
        XCTAssertEqual(connectionType, .wifi)
    }
    
    func testNetworkConnectionType_WhenPathUsesCellular_ShouldReturnCellular() {
        // Given
        let path = createMockPath(status: .satisfied, interfaceTypes: [.cellular])
        
        // When
        let connectionType = NetworkConnectionType(from: path)
        
        // Then
        XCTAssertEqual(connectionType, .cellular)
    }
    
    func testNetworkConnectionType_WhenPathUsesWiredEthernet_ShouldReturnWiredEthernet() {
        // Given
        let path = createMockPath(status: .satisfied, interfaceTypes: [.wiredEthernet])
        
        // When
        let connectionType = NetworkConnectionType(from: path)
        
        // Then
        XCTAssertEqual(connectionType, .wiredEthernet)
    }
    
    func testNetworkConnectionType_WhenPathUsesOther_ShouldReturnOther() {
        // Given
        let path = createMockPath(status: .satisfied, interfaceTypes: [.other])
        
        // When
        let connectionType = NetworkConnectionType(from: path)
        
        // Then
        XCTAssertEqual(connectionType, .other)
    }
    
    func testNetworkConnectionType_WhenPathUsesUnknownInterface_ShouldReturnUnknown() {
        // Given
        let path = createMockPath(status: .satisfied, interfaceTypes: [])
        
        // When
        let connectionType = NetworkConnectionType(from: path)
        
        // Then
        XCTAssertEqual(connectionType, .unknown)
    }
    
    func testNetworkConnectionType_WhenPathUsesMultipleInterfaces_ShouldReturnFirstMatch() {
        // Given - WiFi should take precedence over cellular
        let path = createMockPath(status: .satisfied, interfaceTypes: [.wifi, .cellular])
        
        // When
        let connectionType = NetworkConnectionType(from: path)
        
        // Then
        XCTAssertEqual(connectionType, .wifi)
    }
    
    func testNetworkConnectionType_WhenPathUsesCellularAndEthernet_ShouldReturnCellular() {
        // Given - Cellular should take precedence over ethernet based on order in enum
        let path = createMockPath(status: .satisfied, interfaceTypes: [.cellular, .wiredEthernet])
        
        // When
        let connectionType = NetworkConnectionType(from: path)
        
        // Then
        XCTAssertEqual(connectionType, .cellular)
    }
    
    // MARK: - Description Tests
    
    func testNetworkConnectionTypeDescription_ShouldReturnCorrectStrings() {
        XCTAssertEqual(NetworkConnectionType.wifi.description, "Wifi")
        XCTAssertEqual(NetworkConnectionType.cellular.description, "Cellular")
        XCTAssertEqual(NetworkConnectionType.wiredEthernet.description, "Ethernet")
        XCTAssertEqual(NetworkConnectionType.other.description, "Other")
        XCTAssertEqual(NetworkConnectionType.none.description, "None")
        XCTAssertEqual(NetworkConnectionType.unknown.description, "Unknown")
    }
    
    // MARK: - Raw Value Tests
    
    func testNetworkConnectionTypeRawValues_ShouldBeConsistent() {
        XCTAssertEqual(NetworkConnectionType.wifi.rawValue, 0)
        XCTAssertEqual(NetworkConnectionType.cellular.rawValue, 1)
        XCTAssertEqual(NetworkConnectionType.wiredEthernet.rawValue, 2)
        XCTAssertEqual(NetworkConnectionType.other.rawValue, 3)
        XCTAssertEqual(NetworkConnectionType.none.rawValue, 4)
        XCTAssertEqual(NetworkConnectionType.unknown.rawValue, 5)
    }
    
    func testNetworkConnectionTypeInitFromRawValue_ShouldCreateCorrectInstances() {
        XCTAssertEqual(NetworkConnectionType(rawValue: 0), .wifi)
        XCTAssertEqual(NetworkConnectionType(rawValue: 1), .cellular)
        XCTAssertEqual(NetworkConnectionType(rawValue: 2), .wiredEthernet)
        XCTAssertEqual(NetworkConnectionType(rawValue: 3), .other)
        XCTAssertEqual(NetworkConnectionType(rawValue: 4), .none)
        XCTAssertEqual(NetworkConnectionType(rawValue: 5), .unknown)
        XCTAssertNil(NetworkConnectionType(rawValue: 6))
    }
    
    // MARK: - Helper Methods
    
    private func createMockPath(status: NWPath.Status, interfaceTypes: [NWInterface.InterfaceType]) -> MockNWPath {
        return MockNWPath(status: status, interfaceTypes: interfaceTypes)
    }
}

// MARK: - Mock NWPath for Testing

private class MockNWPath: NWPath {
    private let mockStatus: NWPath.Status
    private let mockInterfaceTypes: [NWInterface.InterfaceType]
    
    init(status: NWPath.Status, interfaceTypes: [NWInterface.InterfaceType]) {
        self.mockStatus = status
        self.mockInterfaceTypes = interfaceTypes
        super.init()
    }
    
    override var status: NWPath.Status {
        return mockStatus
    }
    
    override func usesInterfaceType(_ type: NWInterface.InterfaceType) -> Bool {
        return mockInterfaceTypes.contains(type)
    }
}
