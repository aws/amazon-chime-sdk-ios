//
//  DefaultContentShareControllerTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Mockingbird
import XCTest

class DefaultContentShareControllerTests: XCTestCase {
    var contentShareVideoClientControllerMock: ContentShareVideoClientControllerMock!
    var defaultContentShareController: DefaultContentShareController!

    override func setUp() {
        contentShareVideoClientControllerMock = mock(ContentShareVideoClientController.self)
        defaultContentShareController = DefaultContentShareController(contentShareVideoClientController: contentShareVideoClientControllerMock)
    }

    func testStartContentShareWithValidSource() throws {
        let videoSourceMock: VideoSourceMock! = mock(VideoSource.self)
        let contentShareSource = ContentShareSource()
        contentShareSource.videoSource = videoSourceMock

        defaultContentShareController.startContentShare(source: contentShareSource)

        verify(contentShareVideoClientControllerMock.startVideoShare(source: videoSourceMock)).wasCalled()
    }

    func testStartContentShareWithInvalidSource() throws {
        let contentShareSource = ContentShareSource()

        defaultContentShareController.startContentShare(source: contentShareSource)

        verify(contentShareVideoClientControllerMock.startVideoShare(source: any())).wasNeverCalled()
    }

    func testStopContentShare() throws {
        defaultContentShareController.stopContentShare()

        verify(contentShareVideoClientControllerMock.stopVideoShare()).wasCalled()
    }

    func testAddContentShareObserver() {
        let contentShareObserverMock: ContentShareObserverMock = mock(ContentShareObserver.self)

        defaultContentShareController.addContentShareObserver(observer: contentShareObserverMock)

        verify(contentShareVideoClientControllerMock.subscribeToVideoClientStateChange(observer: contentShareObserverMock)).wasCalled()
    }

    func testRemoveContentShareObserver() {
        let contentShareObserverMock: ContentShareObserverMock = mock(ContentShareObserver.self)

        defaultContentShareController.removeContentShareObserver(observer: contentShareObserverMock)

        verify(contentShareVideoClientControllerMock.unsubscribeFromVideoClientStateChange(observer: contentShareObserverMock)).wasCalled()
    }
}
