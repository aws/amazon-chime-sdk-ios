//
//  DefaultVideoTileTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Mockingbird
import XCTest

class DefaultVideoTileTests: XCTestCase {
    let tileId = 123
    let attendeeId = "123-456-789"
    let videoStreamContentWidth = 1080
    let videoStreamContentHeight = 1920
    let isLocalTile = false

    var loggerMock: LoggerMock!
    var videoRenderViewMock: VideoRenderViewMock!
    var defaultVideoTitle: DefaultVideoTile!

    override func setUp() {
        loggerMock = mock(Logger.self)
        defaultVideoTitle = DefaultVideoTile(tileId: tileId,
                                             attendeeId: attendeeId,
                                             videoStreamContentWidth: videoStreamContentWidth,
                                             videoStreamContentHeight: videoStreamContentHeight,
                                             isLocalTile: isLocalTile,
                                             logger: loggerMock)
    }

    func testBind() {
        videoRenderViewMock = mock(VideoRenderView.self)
        defaultVideoTitle.bind(videoRenderView: videoRenderViewMock)

        verify(loggerMock.info(msg: "Binding the view to tile: tileId: \(tileId), attendeeId: \(attendeeId)")).wasCalled()
        XCTAssert(videoRenderViewMock === defaultVideoTitle.videoRenderView)
    }

    func testRenderFrame() {
        var cVPPixelBuffer: CVPixelBuffer?
        CVPixelBufferCreate(kCFAllocatorDefault, 3840, 2160, kCVPixelFormatType_32ARGB, nil, &cVPPixelBuffer)
        let buffer = VideoFramePixelBuffer(pixelBuffer: cVPPixelBuffer!)
        let frame = VideoFrame(timestampNs: 0, rotation: .rotation0, buffer: buffer)
        videoRenderViewMock = mock(VideoRenderView.self)
        defaultVideoTitle.bind(videoRenderView: videoRenderViewMock)
        defaultVideoTitle.onVideoFrameReceived(frame: frame)

        verify(videoRenderViewMock.onVideoFrameReceived(frame: frame)).wasCalled()
    }

    func testUnbind() {
        defaultVideoTitle.unbind()

        verify(loggerMock.info(msg: "Unbinding the view from tile: tileId: \(tileId), attendeeId: \(attendeeId)")).wasCalled()
        XCTAssertNil(defaultVideoTitle.videoRenderView)
    }

    func testSetPauseState() {
        defaultVideoTitle.setPauseState(pauseState: VideoPauseState.pausedByUserRequest)
        XCTAssertEqual(VideoPauseState.pausedByUserRequest, defaultVideoTitle.state.pauseState)
    }
}
