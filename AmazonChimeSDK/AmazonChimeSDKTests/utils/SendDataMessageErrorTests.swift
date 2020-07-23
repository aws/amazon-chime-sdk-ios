//
//  SendDataMessageErrorTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Foundation
import XCTest

class SendDataMessageErrorTests: XCTestCase {
    func testDescriptionShouldMatch() {
        XCTAssertEqual(SendDataMessageError.invalidDataLength.description, "invalidDataLength")
        XCTAssertEqual(SendDataMessageError.invalidTopic.description, "invalidTopic")
        XCTAssertEqual(SendDataMessageError.negativeLifetimeParameter.description, "negativeLifetimeParameter")
        XCTAssertEqual(SendDataMessageError.invalidData.description, "invalidData")
    }
}
