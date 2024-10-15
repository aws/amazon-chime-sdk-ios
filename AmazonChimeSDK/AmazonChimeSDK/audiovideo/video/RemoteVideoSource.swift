//
//  RemoteVideoSource.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// A video source available in the current meeting. RemoteVideoSource need to be consistent between `remoteVideoSourcesDidBecomeAvailable`
/// and `updateVideoSourceSubscriptions` as they are used as keys in maps that may be updated.
/// I.e. when setting up a map for `updateVideoSourceSubscriptions` do not construct RemoteVideoSource yourselves
/// or the configuration may or may not be updated.
@objcMembers public class RemoteVideoSource: NSObject {
    /// - Parameters:
    ///   -attendeeId: The attendee ID this video tile belongs to. Note that screen share video will have a suffix of #content
    public var attendeeId: String = ""
}
