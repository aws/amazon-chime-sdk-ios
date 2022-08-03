//
//  ContentShareController.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `ContentShareController` exposes methods for starting and stopping content share with a `ContentShareSource`.
/// The content represents a media steam to be shared in the meeting, such as screen capture or media files.
/// Please refer to [content share guide](https://github.com/aws/amazon-chime-sdk-ios/blob/master/guides/content_share.md) for details.
@objc public protocol ContentShareController {
    /// Start sharing the content of a given `ContentShareSource`.
    ///
    /// Once sharing has started successfully, `ContentShareObserver.contentShareDidStart` will
    /// be notified. If sharing fails or stops, `ContentShareObserver.contentShareDidStop`
    /// will be invoked with `ContentShareStatus` as the cause.
    ///
    /// This will call `VideoSource.addVideoSink(sink:)` on the provided source
    /// and `VideoSource.removeVideoSink(sink:)` on the previously provided source.
    ///
    /// Calling this function repeatedly will replace the previous `ContentShareSource` as the one being transmitted.
    ///
    /// - Parameter source: source of content to be shared
    func startContentShare(source: ContentShareSource)

    /// Start sharing the content of a given `ContentShareSource`, with configurations.
    ///
    /// Once sharing has started successfully, `ContentShareObserver.contentShareDidStart` will
    /// be notified. If sharing fails or stops, `ContentShareObserver.contentShareDidStop`
    /// will be invoked with `ContentShareStatus` as the cause.
    ///
    /// This will call `VideoSource.addVideoSink(sink:)` on the provided source
    /// and `VideoSource.removeVideoSink(sink:)` on the previously provided source.
    ///
    /// Calling this function repeatedly will replace the previous `ContentShareSource` as the one being transmitted.
    ///
    /// - Parameter source: source of content to be shared
    /// - Parameter config: configurations of emitted video stream, e.g maxBitRateKbps
    func startContentShare(source: ContentShareSource, config: LocalVideoConfiguration)

    /// Stop sharing the content of a `ContentShareSource` that previously started.
    ///
    /// Once the sharing stops successfully, `ContentShareObserver.contentShareDidStop`
    /// will be invoked with status code `ContentShareStatusCode.OK`.
    func stopContentShare()

    /// Subscribe the given observer to content share events (sharing started and stopped).
    ///
    /// - Parameter observer: observer to be notified for events
    func addContentShareObserver(observer: ContentShareObserver)

    /// Unsubscribe the given observer from content share events.
    ///
    /// - Parameter observer: observer to be removed for events
    func removeContentShareObserver(observer: ContentShareObserver)
}
