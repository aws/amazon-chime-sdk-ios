//
//  DefaultAudioClientTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import AmazonChimeSDKMedia
import XCTest

class DefaultAudioClientTests: XCTestCase {
    var loggerMock: LoggerSpy!
    var defaultAudioClient: DefaultAudioClient!

    override func setUp() {
        loggerMock = LoggerSpy()
        defaultAudioClient = DefaultAudioClient.shared(logger: loggerMock)
    }

    func testShared() {
        XCTAssertNotNil(DefaultAudioClient.shared(logger: loggerMock))
    }

    func testAudioLogCallBack_errorLogLevel() {
        let someErrorMessage = "some error message"
        defaultAudioClient.audioLogCallBack(loglevel_t(rawValue: Constants.fatalLevel), msg: someErrorMessage)

        XCTAssertEqual(loggerMock.errorCalls.filter { $0 == someErrorMessage }.count, 1)
    }

    func testAudioLogCallBack_fatalLogLevel() {
        let someFatalMessage = "some fatal message"
        defaultAudioClient.audioLogCallBack(loglevel_t(rawValue: Constants.errorLevel), msg: someFatalMessage)

        XCTAssertEqual(loggerMock.errorCalls.filter { $0 == someFatalMessage }.count, 1)
    }

    func testAudioLogCallBack_otherLogLevel() {
        let someMessage = "some message"
        defaultAudioClient.audioLogCallBack(loglevel_t(rawValue: 3), msg: someMessage)

        XCTAssertEqual(loggerMock.infoCalls.filter { $0 == someMessage }.count, 0)
    }
}
