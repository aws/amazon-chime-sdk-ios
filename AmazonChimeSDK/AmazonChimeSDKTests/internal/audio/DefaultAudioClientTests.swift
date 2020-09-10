//
//  DefaultAudioClientTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import AmazonChimeSDKMedia
import Mockingbird
import XCTest

class DefaultAudioClientTests: XCTestCase {
    var loggerMock: LoggerMock!
    var defaultAudioClient: DefaultAudioClient!

    override func setUp() {
        loggerMock = mock(Logger.self)
        defaultAudioClient = DefaultAudioClient.shared(logger: loggerMock)
    }

    func testShared() {
        XCTAssertNotNil(DefaultAudioClient.shared(logger: loggerMock))
    }

    func testAudioLogCallBack_errorLogLevel() {
        let someErrorMessage = "some error message"
        defaultAudioClient.audioLogCallBack(loglevel_t(rawValue: Constants.fatalLevel), msg: someErrorMessage)

        verify(loggerMock.error(msg: someErrorMessage)).wasCalled()
    }

    func testAudioLogCallBack_fatalLogLevel() {
        let someFatalMessage = "some fatal message"
        defaultAudioClient.audioLogCallBack(loglevel_t(rawValue: Constants.errorLevel), msg: someFatalMessage)

        verify(loggerMock.error(msg: someFatalMessage)).wasCalled()
    }

    func testAudioLogCallBack_otherLogLevel() {
        let someMessage = "some message"
        defaultAudioClient.audioLogCallBack(loglevel_t(rawValue: 3), msg: someMessage)

        verify(loggerMock.info(msg: someMessage)).wasNeverCalled()
    }
}
