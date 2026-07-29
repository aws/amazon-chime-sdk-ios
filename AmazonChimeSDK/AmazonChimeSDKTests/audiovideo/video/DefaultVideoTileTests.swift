//
//  DefaultVideoTileTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class DefaultVideoTileTests: XCTestCase {
    let tileId = 123
    let attendeeId = "123-456-789"
    let videoStreamContentWidth = 1080
    let videoStreamContentHeight = 1920
    let isLocalTile = false

    var loggerMock: LoggerSpy!
    var videoRenderViewMock: VideoRenderViewSpy!
    var defaultVideoTitle: DefaultVideoTile!

    override func setUp() {
        loggerMock = LoggerSpy()
        defaultVideoTitle = DefaultVideoTile(tileId: tileId,
                                             attendeeId: attendeeId,
                                             videoStreamContentWidth: videoStreamContentWidth,
                                             videoStreamContentHeight: videoStreamContentHeight,
                                             isLocalTile: isLocalTile,
                                             logger: loggerMock)
    }

    func testBind() {
        videoRenderViewMock = VideoRenderViewSpy()
        defaultVideoTitle.bind(videoRenderView: videoRenderViewMock)

        XCTAssertEqual(loggerMock.infoCalls.filter { $0 == "Binding the view to tile: tileId: \(self.tileId), attendeeId: \(self.attendeeId)" }.count, 1)
        XCTAssert(videoRenderViewMock === defaultVideoTitle.videoRenderView)
    }

    func testRenderFrame() {
        var cVPPixelBuffer: CVPixelBuffer?
        CVPixelBufferCreate(kCFAllocatorDefault, 3840, 2160, kCVPixelFormatType_32ARGB, nil, &cVPPixelBuffer)
        let buffer = VideoFramePixelBuffer(pixelBuffer: cVPPixelBuffer!)
        let frame = VideoFrame(timestampNs: 0, rotation: .rotation0, buffer: buffer)
        videoRenderViewMock = VideoRenderViewSpy()
        defaultVideoTitle.bind(videoRenderView: videoRenderViewMock)
        defaultVideoTitle.onVideoFrameReceived(frame: frame)

        XCTAssertEqual(videoRenderViewMock.onVideoFrameReceivedCalls.filter { $0 === frame }.count, 1)
    }

    func testUnbind() {
        defaultVideoTitle.unbind()

        XCTAssertEqual(loggerMock.infoCalls.filter { $0 == "Unbinding the view from tile: tileId: \(self.tileId), attendeeId: \(self.attendeeId)" }.count, 1)
        XCTAssertNil(defaultVideoTitle.videoRenderView)
    }

    func testSetPauseState() {
        defaultVideoTitle.setPauseState(pauseState: VideoPauseState.pausedByUserRequest)
        XCTAssertEqual(VideoPauseState.pausedByUserRequest, defaultVideoTitle.state.pauseState)
    }
}
