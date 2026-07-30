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

        verify(contentShareVideoClientControllerMock.startVideoShareCalls) {
            $0.source === self.videoSourceMock && $0.config == nil
        }
    }

    func testStartContentShareWithInvalidSource() throws {
        let contentShareSource = ContentShareSource()

        defaultContentShareController.startContentShare(source: contentShareSource)

        verify(contentShareVideoClientControllerMock.startVideoShareCalls, never())
    }

    func testStartContentShareWithConfig() {
        let config = LocalVideoConfiguration()
        let contentShareSource = ContentShareSource()
        contentShareSource.videoSource = videoSourceMock

        defaultContentShareController.startContentShare(source: contentShareSource, config: config)

        verify(contentShareVideoClientControllerMock.startVideoShareCalls) {
            $0.source === self.videoSourceMock && $0.config === config
        }
    }

    func testStopContentShare() throws {
        defaultContentShareController.stopContentShare()

        verify(contentShareVideoClientControllerMock.stopVideoShareCallCount)
    }

    func testAddContentShareObserver() {
        let contentShareObserverMock = ContentShareObserverSpy()

        defaultContentShareController.addContentShareObserver(observer: contentShareObserverMock)

        verifyIdentical(contentShareVideoClientControllerMock.subscribeToVideoClientStateChangeCalls, to: contentShareObserverMock)
    }

    func testRemoveContentShareObserver() {
        let contentShareObserverMock = ContentShareObserverSpy()

        defaultContentShareController.removeContentShareObserver(observer: contentShareObserverMock)

        verifyIdentical(contentShareVideoClientControllerMock.unsubscribeFromVideoClientStateChangeCalls, to: contentShareObserverMock)
    }
}
