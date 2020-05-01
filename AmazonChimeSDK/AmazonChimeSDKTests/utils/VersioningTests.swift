//
//  VersioningTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class VersioningTests: XCTestCase {
    func testsdkVersionShouldReturnCurrentVersion() {
        let sdkVersion = Versioning.sdkVersion()
        let currentVersion = Bundle(for: VersioningTests.self).infoDictionary?["CFBundleShortVersionString"] as? String
            ?? ""
        XCTAssertEqual(sdkVersion, currentVersion)
    }
}
