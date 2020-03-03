//
//  VideoTileController.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import CoreGraphics.CGImage
import Foundation

@objc public protocol VideoTileController: VideoTileControllerFacade {
    /// Called whenever there is anew Video frame received for any of the attendee in the meeting
    /// - Parameters:
    ///   - frame: a frame of video
    ///   - profileId: a id of user who is transmitting current frame
    ///   - displayId: a id of tile
    ///   - pauseType: pauseType
    ///   - videoId: unique id that belongs to video being transmitted
    func onReceiveFrame(
        frame: CGImage?,
        profileId: String?,
        displayId: Int,
        pauseType: Int,
        videoId: Int
    )
}
