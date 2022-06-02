//
//  DefaultContentShareController.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDKMedia
import Foundation

@objcMembers public class DefaultContentShareController: NSObject, ContentShareController {
    private let contentShareVideoClientController: ContentShareVideoClientController

    public init(contentShareVideoClientController: ContentShareVideoClientController) {
        self.contentShareVideoClientController = contentShareVideoClientController
        super.init()
    }

    public func startContentShare(source: ContentShareSource) {
        if let videoSource = source.videoSource {
            contentShareVideoClientController.startVideoShare(source: videoSource)
        }
    }

    public func startContentShare(source: ContentShareSource, config: LocalVideoConfiguration) {
        if let videoSource = source.videoSource {
            contentShareVideoClientController.startVideoShare(source: videoSource, config: config)
        }
    }

    public func stopContentShare() {
        contentShareVideoClientController.stopVideoShare()
    }

    public func addContentShareObserver(observer: ContentShareObserver) {
        contentShareVideoClientController.subscribeToVideoClientStateChange(observer: observer)
    }

    public func removeContentShareObserver(observer: ContentShareObserver) {
        contentShareVideoClientController.unsubscribeFromVideoClientStateChange(observer: observer)
    }
}
