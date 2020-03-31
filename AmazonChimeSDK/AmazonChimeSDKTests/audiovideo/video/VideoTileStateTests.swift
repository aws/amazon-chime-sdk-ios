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

    func testVideoTileStateShouldBeInitialized() {
        let videoTileState = VideoTileState(tileId: tileId, attendeeId: attendeeId, pauseState: pauseState)

        XCTAssertEqual(videoTileState.tileId, tileId)
        XCTAssertEqual(videoTileState.attendeeId, attendeeId)
        XCTAssertEqual(videoTileState.pauseState, pauseState)
        XCTAssertFalse(videoTileState.isLocalTile)
        XCTAssertFalse(videoTileState.isContent)
    }

    func testVideoTileStateShouldBeInitializedAsLocalVideoViewWhenAttendeeIdIsEmpty() {
        let videoTileState = VideoTileState(tileId: tileId, attendeeId: nil, pauseState: pauseState)

        XCTAssertEqual(videoTileState.tileId, tileId)
        XCTAssertEqual(videoTileState.pauseState, pauseState)
        XCTAssertTrue(videoTileState.isLocalTile)
        XCTAssertFalse(videoTileState.isContent)
    }

    func testVideoTileStateShouldBeInitializedAsScreenShareViewWhenAttendeeIdContainsContentKeyword() {
        let videoTileState = VideoTileState(tileId: tileId, attendeeId: screenShareAttendeeId, pauseState: pauseState)

        XCTAssertEqual(videoTileState.tileId, tileId)
        XCTAssertEqual(videoTileState.attendeeId, screenShareAttendeeId)
        XCTAssertEqual(videoTileState.pauseState, pauseState)
        XCTAssertFalse(videoTileState.isLocalTile)
        XCTAssertTrue(videoTileState.isContent)
    }
}
