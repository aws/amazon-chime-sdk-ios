//
//  VideoTileController.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import CoreGraphics.CGImage
import Foundation

/// `VideoTileController` handles rendering/creating of new `VideoTile`.
@objc public protocol VideoTileController: VideoTileControllerFacade {
    /// Called whenever there is a new Video frame received for any of the attendee in the meeting
    /// - Parameters:
    ///   - frame: a frame of video
    ///   - attendeeId: a id of user who is transmitting current frame
    ///   - videoId: unique id that belongs to video being transmitted
    func onReceiveFrame(
        frame: Any?,
        attendeeId: String?,
        videoId: Int
    )
}
