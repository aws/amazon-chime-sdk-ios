//
//  VideoTileController.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import CoreGraphics.CGImage
import Foundation
import VideoToolbox

/// `VideoTileController` handles rendering/creating of new `VideoTile`.
@objc public protocol VideoTileController: VideoTileControllerFacade {
    /// Called whenever there is a new Video frame received for any of the attendee in the meeting
    /// - Parameters:
    ///   - frame: a frame of video
    ///   - videoId: unique id that belongs to video being transmitted
    ///   - attendeeId: a id of user who is transmitting current frame
    ///   - pauseState: current pause state of the video being received
    func onReceiveFrame(
        frame: VideoFrame?,
        videoId: Int,
        attendeeId: String?,
        pauseState: VideoPauseState
    )
}
