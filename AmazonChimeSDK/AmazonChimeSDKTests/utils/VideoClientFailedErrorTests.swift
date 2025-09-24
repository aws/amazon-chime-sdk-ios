//
//  VideoClientFailedErrorTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest
import AmazonChimeSDKMedia

class VideoClientFailedErrorTests: XCTestCase {
    
    func testInitFromVideoClientStatus_ShouldReturnMatchingError() {
        XCTAssertEqual(
            VideoClientFailedError.init(from: VIDEO_CLIENT_ERR_PROXY_AUTHENTICATION_FAILED),
            VideoClientFailedError.authenticationFailed)
        XCTAssertEqual(
            VideoClientFailedError.init(from: VIDEO_CLIENT_ERR_PEERCONN_CREATE_FAILED),
            VideoClientFailedError.peerConnectionCreateFailed)
        XCTAssertEqual(
            VideoClientFailedError.init(from: VIDEO_CLIENT_ERR_MAX_RETRY_PERIOD_EXCEEDED),
            VideoClientFailedError.maxRetryPeriodExceeded)
        XCTAssertEqual(
            VideoClientFailedError.init(from: VIDEO_CLIENT_ERR_INVALID_PARAMETER),
            VideoClientFailedError.other)
    }
    
    func testDescriptionShouldMatch() {
        XCTAssertEqual(VideoClientFailedError.authenticationFailed.description, "authenticationFailed")
        XCTAssertEqual(VideoClientFailedError.peerConnectionCreateFailed.description, "peerConnectionCreateFailed")
        XCTAssertEqual(VideoClientFailedError.maxRetryPeriodExceeded.description, "maxRetryPeriodExceeded")
        XCTAssertEqual(VideoClientFailedError.other.description, "other")
    }
}
