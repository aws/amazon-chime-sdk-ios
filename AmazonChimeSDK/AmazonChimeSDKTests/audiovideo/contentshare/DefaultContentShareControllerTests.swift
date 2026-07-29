//
//  DefaultContentShareControllerTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class DefaultContentShareControllerTests: XCTestCase {
    var contentShareVideoClientControllerMock: ContentShareVideoClientControllerSpy!
    var defaultContentShareController: DefaultContentShareController!
    var videoSourceMock: VideoSourceSpy!

    override func setUp() {
        videoSourceMock = VideoSourceSpy()
        contentShareVideoClientControllerMock = ContentShareVideoClientControllerSpy()
        defaultContentShareController = DefaultContentShareController(contentShareVideoClientController: contentShareVideoClientControllerMock)
    }

    func testStartContentShareWithValidSource() throws {
        let contentShareSource = ContentShareSource()
        contentShareSource.videoSource = videoSourceMock

        defaultContentShareController.startContentShare(source: contentShareSource)

        XCTAssertEqual(contentShareVideoClientControllerMock.startVideoShareCalls.filter { $0.source === self.videoSourceMock && $0.config == nil }.count, 1)
    }

    func testStartContentShareWithInvalidSource() throws {
        let contentShareSource = ContentShareSource()

        defaultContentShareController.startContentShare(source: contentShareSource)

        XCTAssertEqual(contentShareVideoClientControllerMock.startVideoShareCalls.count, 0)
    }

    func testStartContentShareWithConfig() {
        let config = LocalVideoConfiguration()
        let contentShareSource = ContentShareSource()
        contentShareSource.videoSource = videoSourceMock

        defaultContentShareController.startContentShare(source: contentShareSource, config: config)

        XCTAssertEqual(contentShareVideoClientControllerMock.startVideoShareCalls.filter { $0.source === self.videoSourceMock && $0.config === config }.count, 1)
    }

    func testStopContentShare() throws {
        defaultContentShareController.stopContentShare()

        XCTAssertEqual(contentShareVideoClientControllerMock.stopVideoShareCallCount, 1)
    }

    func testAddContentShareObserver() {
        let contentShareObserverMock = ContentShareObserverSpy()

        defaultContentShareController.addContentShareObserver(observer: contentShareObserverMock)

        XCTAssertEqual(contentShareVideoClientControllerMock.subscribeToVideoClientStateChangeCalls.filter { $0 === contentShareObserverMock }.count, 1)
    }

    func testRemoveContentShareObserver() {
        let contentShareObserverMock = ContentShareObserverSpy()

        defaultContentShareController.removeContentShareObserver(observer: contentShareObserverMock)

        XCTAssertEqual(contentShareVideoClientControllerMock.unsubscribeFromVideoClientStateChangeCalls.filter { $0 === contentShareObserverMock }.count, 1)
    }
}
