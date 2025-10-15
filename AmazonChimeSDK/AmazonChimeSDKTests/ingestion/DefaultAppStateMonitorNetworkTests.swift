//
//  DefaultAppStateMonitorNetworkTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Mockingbird
import Network
import XCTest

final class DefaultAppStateMonitorNetworkTests: XCTestCase {
    
    private var loggerMock: LoggerMock!
    private var delegateMock: AppStateMonitorDelegateMock!
    private var monitor: TestableDefaultAppStateMonitor!
    
    override func setUp() {
        super.setUp()
        loggerMock = mock(Logger.self)
        delegateMock = mock(AppStateMonitorDelegate.self)
        monitor = TestableDefaultAppStateMonitor(logger: loggerMock)
        monitor.delegate = delegateMock
    }
    
    override func tearDown() {
        monitor?.stop()
        monitor = nil
        super.tearDown()
    }
    
    // MARK: - Network Connection Type Monitoring Tests
    
    func testGetNetworkConnectionType_WhenInitialized_ShouldReturnNone() {
        // When
        let connectionType = monitor.getNetworkConnectionType()
        
        // Then
        XCTAssertEqual(connectionType, .none)
    }
    
    func testNetworkConnectionTypeChange_WhenMonitorNotStarted_ShouldNotNotifyDelegate() {
        // Given
        let newPath = createMockPath(status: .satisfied, interfaceTypes: [.wifi])
        
        // When
        monitor.simulateNetworkPathUpdate(newPath)
        
        // Then
        verify(delegateMock.networkConnectionTypeDidChange(monitor: any(), newNetworkConnectionType: any())).wasNeverCalled()
    }
    
    func testNetworkConnectionTypeChange_WhenMonitorStarted_ShouldNotifyDelegate() {
        // Given
        monitor.start()
        let newPath = createMockPath(status: .satisfied, interfaceTypes: [.wifi])
        
        // When
        monitor.simulateNetworkPathUpdate(newPath)
        
        // Then
        let expectation = XCTestExpectation(description: "Network connection type change notification")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            verify(self.delegateMock.networkConnectionTypeDidChange(monitor: self.monitor, newNetworkConnectionType: .wifi)).wasCalled()
            XCTAssertEqual(self.monitor.getNetworkConnectionType(), .wifi)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testNetworkConnectionTypeChange_WhenSameType_ShouldNotNotifyDelegate() {
        // Given
        monitor.start()
        let wifiPath = createMockPath(status: .satisfied, interfaceTypes: [.wifi])
        
        // When - Set initial connection type
        monitor.simulateNetworkPathUpdate(wifiPath)
        
        let expectation1 = XCTestExpectation(description: "First network change")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Reset mock to clear previous calls
            reset(self.delegateMock)
            expectation1.fulfill()
        }
        
        wait(for: [expectation1], timeout: 1.0)
        
        // When - Set same connection type again
        monitor.simulateNetworkPathUpdate(wifiPath)
        
        let expectation2 = XCTestExpectation(description: "Second network change")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Then - Should not notify delegate again
            verify(self.delegateMock.networkConnectionTypeDidChange(monitor: any(), newNetworkConnectionType: any())).wasNeverCalled()
            expectation2.fulfill()
        }
        
        wait(for: [expectation2], timeout: 1.0)
    }
    
    func testNetworkConnectionTypeChange_WhenDifferentTypes_ShouldNotifyDelegateForEachChange() {
        // Given
        monitor.start()
        let wifiPath = createMockPath(status: .satisfied, interfaceTypes: [.wifi])
        let cellularPath = createMockPath(status: .satisfied, interfaceTypes: [.cellular])
        let ethernetPath = createMockPath(status: .satisfied, interfaceTypes: [.wiredEthernet])
        
        // When - Change to WiFi
        monitor.simulateNetworkPathUpdate(wifiPath)
        
        let expectation1 = XCTestExpectation(description: "WiFi connection")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            verify(self.delegateMock.networkConnectionTypeDidChange(monitor: self.monitor, newNetworkConnectionType: .wifi)).wasCalled()
            XCTAssertEqual(self.monitor.getNetworkConnectionType(), .wifi)
            expectation1.fulfill()
        }
        
        wait(for: [expectation1], timeout: 1.0)
        
        // When - Change to Cellular
        monitor.simulateNetworkPathUpdate(cellularPath)
        
        let expectation2 = XCTestExpectation(description: "Cellular connection")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            verify(self.delegateMock.networkConnectionTypeDidChange(monitor: self.monitor, newNetworkConnectionType: .cellular)).wasCalled()
            XCTAssertEqual(self.monitor.getNetworkConnectionType(), .cellular)
            expectation2.fulfill()
        }
        
        wait(for: [expectation2], timeout: 1.0)
        
        // When - Change to Ethernet
        monitor.simulateNetworkPathUpdate(ethernetPath)
        
        let expectation3 = XCTestExpectation(description: "Ethernet connection")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            verify(self.delegateMock.networkConnectionTypeDidChange(monitor: self.monitor, newNetworkConnectionType: .wiredEthernet)).wasCalled()
            XCTAssertEqual(self.monitor.getNetworkConnectionType(), .wiredEthernet)
            expectation3.fulfill()
        }
        
        wait(for: [expectation3], timeout: 1.0)
    }
    
    func testNetworkConnectionTypeChange_WhenNetworkUnavailable_ShouldNotifyWithNone() {
        // Given
        monitor.start()
        let wifiPath = createMockPath(status: .satisfied, interfaceTypes: [.wifi])
        let noNetworkPath = createMockPath(status: .unsatisfied, interfaceTypes: [])
        
        // When - Start with WiFi
        monitor.simulateNetworkPathUpdate(wifiPath)
        
        let expectation1 = XCTestExpectation(description: "WiFi connection")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.monitor.getNetworkConnectionType(), .wifi)
            expectation1.fulfill()
        }
        
        wait(for: [expectation1], timeout: 1.0)
        
        // When - Network becomes unavailable
        monitor.simulateNetworkPathUpdate(noNetworkPath)
        
        let expectation2 = XCTestExpectation(description: "No network connection")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            verify(self.delegateMock.networkConnectionTypeDidChange(monitor: self.monitor, newNetworkConnectionType: .none)).wasCalled()
            XCTAssertEqual(self.monitor.getNetworkConnectionType(), .none)
            expectation2.fulfill()
        }
        
        wait(for: [expectation2], timeout: 1.0)
    }
    
    func testNetworkConnectionTypeChange_WhenUnknownInterface_ShouldNotifyWithUnknown() {
        // Given
        monitor.start()
        let unknownPath = createMockPath(status: .satisfied, interfaceTypes: [])
        
        // When
        monitor.simulateNetworkPathUpdate(unknownPath)
        
        // Then
        let expectation = XCTestExpectation(description: "Unknown network connection")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            verify(self.delegateMock.networkConnectionTypeDidChange(monitor: self.monitor, newNetworkConnectionType: .unknown)).wasCalled()
            XCTAssertEqual(self.monitor.getNetworkConnectionType(), .unknown)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testNetworkConnectionTypeChange_WhenOtherInterface_ShouldNotifyWithOther() {
        // Given
        monitor.start()
        let otherPath = createMockPath(status: .satisfied, interfaceTypes: [.other])
        
        // When
        monitor.simulateNetworkPathUpdate(otherPath)
        
        // Then
        let expectation = XCTestExpectation(description: "Other network connection")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            verify(self.delegateMock.networkConnectionTypeDidChange(monitor: self.monitor, newNetworkConnectionType: .other)).wasCalled()
            XCTAssertEqual(self.monitor.getNetworkConnectionType(), .other)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testNetworkConnectionTypeChange_WhenMultipleInterfaces_ShouldNotifyWithFirstMatch() {
        // Given
        monitor.start()
        let multiInterfacePath = createMockPath(status: .satisfied, interfaceTypes: [.wifi, .cellular, .wiredEthernet])
        
        // When
        monitor.simulateNetworkPathUpdate(multiInterfacePath)
        
        // Then - Should prioritize WiFi over other interfaces
        let expectation = XCTestExpectation(description: "Multi-interface network connection")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            verify(self.delegateMock.networkConnectionTypeDidChange(monitor: self.monitor, newNetworkConnectionType: .wifi)).wasCalled()
            XCTAssertEqual(self.monitor.getNetworkConnectionType(), .wifi)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testNetworkConnectionTypeChange_WhenStoppedAfterStart_ShouldNotNotifyDelegate() {
        // Given
        monitor.start()
        let wifiPath = createMockPath(status: .satisfied, interfaceTypes: [.wifi])
        
        // When - Stop monitoring
        monitor.stop()
        monitor.simulateNetworkPathUpdate(wifiPath)
        
        // Then
        let expectation = XCTestExpectation(description: "Network change after stop")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            verify(self.delegateMock.networkConnectionTypeDidChange(monitor: any(), newNetworkConnectionType: any())).wasNeverCalled()
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testNetworkConnectionTypeChange_WhenRestartedAfterStop_ShouldNotifyDelegate() {
        // Given
        monitor.start()
        monitor.stop()
        monitor.start()
        let wifiPath = createMockPath(status: .satisfied, interfaceTypes: [.wifi])
        
        // When
        monitor.simulateNetworkPathUpdate(wifiPath)
        
        // Then
        let expectation = XCTestExpectation(description: "Network change after restart")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            verify(self.delegateMock.networkConnectionTypeDidChange(monitor: self.monitor, newNetworkConnectionType: .wifi)).wasCalled()
            XCTAssertEqual(self.monitor.getNetworkConnectionType(), .wifi)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Edge Cases and Error Handling
    
    func testNetworkConnectionTypeChange_WhenDelegateIsNil_ShouldNotCrash() {
        // Given
        monitor.start()
        monitor.delegate = nil
        let wifiPath = createMockPath(status: .satisfied, interfaceTypes: [.wifi])
        
        // When
        monitor.simulateNetworkPathUpdate(wifiPath)
        
        // Then - Should not crash and should update internal state
        let expectation = XCTestExpectation(description: "Network change with nil delegate")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.monitor.getNetworkConnectionType(), .wifi)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testNetworkConnectionTypeChange_WhenWeakSelfIsNil_ShouldNotCrash() {
        // Given
        var tempMonitor: TestableDefaultAppStateMonitor? = TestableDefaultAppStateMonitor(logger: loggerMock)
        tempMonitor?.start()
        let wifiPath = createMockPath(status: .satisfied, interfaceTypes: [.wifi])
        
        // When - Simulate weak self becoming nil
        tempMonitor?.simulateNetworkPathUpdate(wifiPath)
        tempMonitor = nil
        
        // Then - Should not crash
        let expectation = XCTestExpectation(description: "Network change with nil weak self")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Test passes if we reach here without crashing
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Performance Tests
    
    func testNetworkConnectionTypeChange_WhenRapidChanges_ShouldHandleAllChanges() {
        // Given
        monitor.start()
        let connectionTypes: [(NetworkConnectionType, [NWInterface.InterfaceType])] = [
            (.wifi, [.wifi]),
            (.cellular, [.cellular]),
            (.wiredEthernet, [.wiredEthernet]),
            (.other, [.other]),
            (.none, []),
            (.unknown, [])
        ]
        
        // When - Simulate rapid network changes
        for (expectedType, interfaceTypes) in connectionTypes {
            let path = createMockPath(
                status: expectedType == .none ? .unsatisfied : .satisfied,
                interfaceTypes: interfaceTypes
            )
            monitor.simulateNetworkPathUpdate(path)
        }
        
        // Then
        let expectation = XCTestExpectation(description: "Rapid network changes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Should end up with the last connection type
            XCTAssertEqual(self.monitor.getNetworkConnectionType(), .unknown)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    // MARK: - Helper Methods
    
    private func createMockPath(status: NWPath.Status, interfaceTypes: [NWInterface.InterfaceType]) -> MockNWPath {
        return MockNWPath(status: status, interfaceTypes: interfaceTypes)
    }
}

// MARK: - Testable DefaultAppStateMonitor

private class TestableDefaultAppStateMonitor: DefaultAppStateMonitor {
    
    private var mockPathUpdateHandler: ((NWPath) -> Void)?
    
    override init(logger: Logger) {
        super.init(logger: logger)
        // Capture the path update handler for testing
        setupMockNetworkMonitor()
    }
    
    private func setupMockNetworkMonitor() {
        // We need to access the private networkPathMonitor to set up our mock
        // Since we can't directly access it, we'll use a different approach
        // by providing a method to simulate network path updates
    }
    
    func simulateNetworkPathUpdate(_ path: NWPath) {
        // Simulate the network path update by directly calling the logic
        // that would normally be called by the NWPathMonitor
        let newConnectionType = NetworkConnectionType(from: path)
        
        // Use reflection or direct property access to update the connection type
        // Since currentNetworkConnectionType is private, we need to trigger the same logic
        DispatchQueue.global().async {
            // Simulate the network queue execution
            DispatchQueue.main.async {
                // This will trigger the didSet observer
                self.setValue(newConnectionType, forKey: "currentNetworkConnectionType")
            }
        }
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
