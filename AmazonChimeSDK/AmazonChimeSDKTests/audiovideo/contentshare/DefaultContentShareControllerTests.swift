//
//  DefaultContentShareControllerTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Cuckoo
import XCTest

class DefaultContentShareControllerTests: XCTestCase {
    var contentShareVideoClientControllerMock: MockContentShareVideoClientController!
    var defaultContentShareController: DefaultContentShareController!
    var videoSourceMock: MockVideoSource!

    override func setUp() {
        videoSourceMock = MockVideoSource().withEnabledDefaultImplementation(VideoSourceStub())
        contentShareVideoClientControllerMock = MockContentShareVideoClientController().withEnabledDefaultImplementation(ContentShareVideoClientControllerStub())
        defaultContentShareController = DefaultContentShareController(contentShareVideoClientController: contentShareVideoClientControllerMock)
    }

    func testStartContentShareWithValidSource() throws {
        let contentShareSource = ContentShareSource()
        contentShareSource.videoSource = videoSourceMock

        defaultContentShareController.startContentShare(source: contentShareSource)

        verify(contentShareVideoClientControllerMock).startVideoShare(source: equal(to: self.videoSourceMock))
    }

    func testStartContentShareWithInvalidSource() throws {
        let contentShareSource = ContentShareSource()

        defaultContentShareController.startContentShare(source: contentShareSource)

        verify(contentShareVideoClientControllerMock, never()).startVideoShare(source: any())
    }

    func testStartContentShareWithConfig() {
        let config = LocalVideoConfiguration()
        let contentShareSource = ContentShareSource()
        contentShareSource.videoSource = videoSourceMock

        defaultContentShareController.startContentShare(source: contentShareSource, config: config)

        verify(contentShareVideoClientControllerMock).startVideoShare(source: equal(to: self.videoSourceMock), config: equal(to: config))
    }

    func testStopContentShare() throws {
        defaultContentShareController.stopContentShare()

        verify(contentShareVideoClientControllerMock).stopVideoShare()
    }

    func testAddContentShareObserver() {
        let contentShareObserverMock: MockContentShareObserver = MockContentShareObserver().withEnabledDefaultImplementation(ContentShareObserverStub())

        defaultContentShareController.addContentShareObserver(observer: contentShareObserverMock)

        verify(contentShareVideoClientControllerMock).subscribeToVideoClientStateChange(observer: equal(to: contentShareObserverMock))
    }

    func testRemoveContentShareObserver() {
        let contentShareObserverMock: MockContentShareObserver = MockContentShareObserver().withEnabledDefaultImplementation(ContentShareObserverStub())

        defaultContentShareController.removeContentShareObserver(observer: contentShareObserverMock)

        verify(contentShareVideoClientControllerMock).unsubscribeFromVideoClientStateChange(observer: equal(to: contentShareObserverMock))
    }
}
