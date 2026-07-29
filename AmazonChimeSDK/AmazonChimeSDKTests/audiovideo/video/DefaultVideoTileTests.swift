//
//  DefaultVideoTileTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Cuckoo
import XCTest

class DefaultVideoTileTests: XCTestCase {
    let tileId = 123
    let attendeeId = "123-456-789"
    let videoStreamContentWidth = 1080
    let videoStreamContentHeight = 1920
    let isLocalTile = false

    var loggerMock: MockLogger!
    var videoRenderViewMock: MockVideoRenderView!
    var defaultVideoTitle: DefaultVideoTile!

    override func setUp() {
        loggerMock = MockLogger().withEnabledDefaultImplementation(LoggerStub())
        defaultVideoTitle = DefaultVideoTile(tileId: tileId,
                                             attendeeId: attendeeId,
                                             videoStreamContentWidth: videoStreamContentWidth,
                                             videoStreamContentHeight: videoStreamContentHeight,
                                             isLocalTile: isLocalTile,
                                             logger: loggerMock)
    }

    func testBind() {
        videoRenderViewMock = MockVideoRenderView().withEnabledDefaultImplementation(VideoRenderViewStub())
        defaultVideoTitle.bind(videoRenderView: videoRenderViewMock)

        verify(loggerMock).info(msg: "Binding the view to tile: tileId: \(self.tileId), attendeeId: \(self.attendeeId)")
        XCTAssert(videoRenderViewMock === defaultVideoTitle.videoRenderView)
    }

    func testRenderFrame() {
        var cVPPixelBuffer: CVPixelBuffer?
        CVPixelBufferCreate(kCFAllocatorDefault, 3840, 2160, kCVPixelFormatType_32ARGB, nil, &cVPPixelBuffer)
        let buffer = VideoFramePixelBuffer(pixelBuffer: cVPPixelBuffer!)
        let frame = VideoFrame(timestampNs: 0, rotation: .rotation0, buffer: buffer)
        videoRenderViewMock = MockVideoRenderView().withEnabledDefaultImplementation(VideoRenderViewStub())
        defaultVideoTitle.bind(videoRenderView: videoRenderViewMock)
        defaultVideoTitle.onVideoFrameReceived(frame: frame)

        verify(videoRenderViewMock).onVideoFrameReceived(frame: equal(to: frame))
    }

    func testUnbind() {
        defaultVideoTitle.unbind()

        verify(loggerMock).info(msg: "Unbinding the view from tile: tileId: \(self.tileId), attendeeId: \(self.attendeeId)")
        XCTAssertNil(defaultVideoTitle.videoRenderView)
    }

    func testSetPauseState() {
        defaultVideoTitle.setPauseState(pauseState: VideoPauseState.pausedByUserRequest)
        XCTAssertEqual(VideoPauseState.pausedByUserRequest, defaultVideoTitle.state.pauseState)
    }
}
