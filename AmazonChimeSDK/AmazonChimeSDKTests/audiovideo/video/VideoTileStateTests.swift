//
//  VideoTileStateTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import XCTest

class VideoTileStateTests: XCTestCase {
    private let tileId = 0
    private let attendeeId = "attendeeId"
    private let screenShareAttendeeId = "attendeeId#content"
    private let pauseState = VideoPauseState.unpaused
    private let videoStreamContentHeight = 1280
    private let videoStreamContentWidth = 720

    private var videoTileState: VideoTileState?

    func testVideoTileStateShouldBeInitialized() {
        videoTileState = VideoTileState(tileId: tileId,
                                        attendeeId: attendeeId,
                                        videoStreamContentHeight: videoStreamContentHeight,
                                        videoStreamContentWidth: videoStreamContentWidth,
                                        pauseState: pauseState)
        XCTAssertEqual(videoTileState?.tileId, tileId)
        XCTAssertEqual(videoTileState?.attendeeId, attendeeId)
        XCTAssertEqual(videoTileState?.videoStreamContentHeight, videoStreamContentHeight)
        XCTAssertEqual(videoTileState?.videoStreamContentWidth, videoStreamContentWidth)
        XCTAssertEqual(videoTileState?.pauseState, pauseState)
        XCTAssertEqual(videoTileState?.isLocalTile, false)
        XCTAssertEqual(videoTileState?.isContent, false)
    }

    func testVideoTileStateShouldBeInitializedAsLocalVideoViewWhenAttendeeIdIsEmpty() {
        videoTileState = VideoTileState(tileId: tileId,
                                        attendeeId: nil,
                                        videoStreamContentHeight: videoStreamContentHeight,
                                        videoStreamContentWidth: videoStreamContentWidth,
                                        pauseState: pauseState)

        XCTAssertEqual(videoTileState?.tileId, tileId)
        XCTAssertEqual(videoTileState?.pauseState, pauseState)
        XCTAssertEqual(videoTileState?.isLocalTile, true)
        XCTAssertEqual(videoTileState?.isContent, false)
    }

    func testVideoTileStateShouldBeInitializedAsScreenShareViewWhenAttendeeIdContainsContentKeyword() {
        videoTileState = VideoTileState(tileId: tileId,
                                        attendeeId: screenShareAttendeeId,
                                        videoStreamContentHeight: videoStreamContentHeight,
                                        videoStreamContentWidth: videoStreamContentWidth,
                                        pauseState: pauseState)

        XCTAssertEqual(videoTileState?.tileId, tileId)
        XCTAssertEqual(videoTileState?.attendeeId, screenShareAttendeeId)
        XCTAssertEqual(videoTileState?.pauseState, pauseState)
        XCTAssertEqual(videoTileState?.isLocalTile, false)
        XCTAssertEqual(videoTileState?.isContent, true)
    }
}
