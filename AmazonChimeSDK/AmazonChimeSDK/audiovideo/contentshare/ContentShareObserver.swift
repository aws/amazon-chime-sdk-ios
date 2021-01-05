//
//  ContentShareObserver.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `ContentShareObserver` handles all callbacks related to the content share.
/// By implementing the callback functions and registering with `ContentShareController.addContentShareObserver`,
/// one can get notified with content share status events.
@objc public protocol ContentShareObserver {
    /// Called when the content share has started.
    /// This callback will be called on the main thread.
    func contentShareDidStart()

    /// Called when the content is no longer shared with other attendees with the reason provided in the status.
    /// If you no longer need the source producing frames, stop the source after this callback is invoked.
    /// This callback will be called on the main thread.
    ///
    /// - Parameter status: the reason why the content share has stopped
    func contentShareDidStop(status: ContentShareStatus)
}
